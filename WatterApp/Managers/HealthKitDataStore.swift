//
//  HealthKitDataStore.swift
//  WatterApp
//
//  Created by IsraelBerezin on 22/12/2022.
//

import Foundation
import HealthKit
import CoreLocation
import MapKit

class HealthKitDataStore {
    // MARK: - Properties
    var healthStore: HKHealthStore!
    
    public func requestAuthorisation(completion: @escaping (String?) -> Void) {
        // Check healthkit is available
        if !HKHealthStore.isHealthDataAvailable() {
            completion("Health data not available")
            return
        }
        healthStore = HKHealthStore()
        
        // Request authorisation to use health store
        // The quantity type to write to the health store
        let typesToShare: Set = [
            HKObjectType.workoutType(),
            HKSeriesType.workoutRoute()
        ]
        // The quantity type to read from the health store
        let typesToRead: Set = [
            HKObjectType.workoutType(),
            HKSeriesType.workoutRoute()
            
        ]
        
        let allTypes = Set([HKObjectType.workoutType(),
                            HKSeriesType.workoutRoute(),
                            HKObjectType.quantityType(forIdentifier: .stepCount)!,
                            HKObjectType.quantityType(forIdentifier: .height)!,
                            HKObjectType.quantityType(forIdentifier: .walkingSpeed)!,
                            HKObjectType.quantityType(forIdentifier: .walkingStepLength)!,

                            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                            HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                            HKObjectType.quantityType(forIdentifier: .heartRate)!])

        
        // Request authorization for those quantity types
        healthStore.requestAuthorization(toShare: typesToShare, read: allTypes) { (success, error) in
            if error != nil {
                completion(error!.localizedDescription)
                return
            }
            completion(nil)
        }
    }
    
    // MARK: - Public Methods
    // Load all workouts and associated data
    public func loadAllWorkouts(completion: @escaping ([Workout]) -> Void) {
        // Load workouts
        self.loadWorkouts { (workouts, error) in
            if error == true || workouts!.isEmpty {
                print("No Workouts Returned by Health Store")
                completion([])
                return
            }
            
            var tally: Int = 0
            var newWorkouts: [Workout] = []
            
            // Load each workout route's data
            for workout in workouts! {
                self.loadWorkoutRoute(workout: workout) { (locations, formattedLocations, error) in
                    tally += 1
                    if error == true {
                        if tally == workouts!.count {
                            completion(newWorkouts)
                        }
                        return
                    }
                    
                    let newWorkoutPolyline = MulticolourPolyline(coordinates: formattedLocations!, count: formattedLocations!.count)
                    switch workout.workoutActivityType {
                    case .running:
                        newWorkoutPolyline.colour = .systemRed
                    case .walking:
                        newWorkoutPolyline.colour = .systemGreen
                    case .cycling:
                        newWorkoutPolyline.colour = .systemBlue
                    default:
                        newWorkoutPolyline.colour = .systemYellow
                    }
                    
                    // Instantiate new workout
                    let newWorkout = Workout(
                        workout: workout,
                        workoutType: workout.workoutActivityType,
                        routeLocations: locations!,
                        routePolylines: [newWorkoutPolyline],
                        date: workout.startDate,
                        distance: workout.totalDistance?.doubleValue(for: HKUnit.meter()),
                        duration: workout.duration,
                        calories: workout.totalEnergyBurned?.doubleValue(for: HKUnit.kilocalorie())
                    )
                    
                    newWorkouts.append(newWorkout)
                    if tally == workouts!.count {
                        completion(newWorkouts)
                    }
                }
            }
        }
    }
    
    
    func getDistanceWalkingRunning(completion:@escaping (_ count: Double)-> Void){
        guard let type = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            fatalError("Something went wrong retriebing quantity type distanceWalkingRunning")
        }
        let date =  Date()
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let newDate = cal.startOfDay(for: date)

        let predicate = HKQuery.predicateForSamples(withStart: newDate, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: [.cumulativeSum]) { (query, statistics, error) in
            var value: Double = 0

            if error != nil {
                print("something went wrong")
            } else if let quantity = statistics?.sumQuantity() {
                value = quantity.doubleValue(for: HKUnit.meter())
            }
            DispatchQueue.main.async {
                completion(value)
            }
        }
        healthStore.execute(query)

    }
    func getStepCountPerDay(completion:@escaping (_ count: Double)-> Void){

        guard let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount)
            else {
                return
        }
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 1

        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)

        let stepsCumulativeQuery = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: dateComponents
        )

        // Set the results handler
        stepsCumulativeQuery.initialResultsHandler = {query, results, error in
            let endDate = Date()
            let startDate = calendar.date(byAdding: .day, value: 0, to: endDate, wrappingComponents: false)
            if let myResults = results{
                myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, stop in
                    if let quantity = statistics.sumQuantity(){
                        let date = statistics.startDate
                        let steps = quantity.doubleValue(for: HKUnit.count())
                        print("\(date): steps = \(steps)")
                        completion(steps)
                        //NOTE: If you are going to update the UI do it in the main thread
                        DispatchQueue.main.async {
                            //update UI components
                        }
                    }
                } //end block
            } //end if let
        }
        HKHealthStore().execute(stepsCumulativeQuery)
    }
    
    // MARK: - Private Methods
    // Load an array of all workouts
    private func loadWorkouts(completion: @escaping ([HKWorkout]?, Bool) -> Void) {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        // Query the workouts
        let workoutsQuery = HKSampleQuery(sampleType: .workoutType(), predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            guard let workoutSamples = samples as? [HKWorkout] else {
                completion(nil, true)
                return
            }
            // Do something with the array of workouts
            completion(workoutSamples, false)
        }
        healthStore.execute(workoutsQuery)
    }
    
    // Load an array of location data for a specific workout
    private func loadWorkoutRoute(workout: HKWorkout, completion: @escaping ([CLLocation]?, [CLLocationCoordinate2D]?, Bool) -> Void) {
        // Setup predicate for query
        let workoutRouteType = HKSeriesType.workoutRoute()
        let workoutPredicate = HKQuery.predicateForObjects(from: workout)
        
        // Query for workout route
        let workoutRouteQuery = HKSampleQuery(sampleType: workoutRouteType, predicate: workoutPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            guard let workoutRoutes = samples as? [HKWorkoutRoute] else {
                completion(nil, nil, true)
                return
            }
            if workoutRoutes.isEmpty {
                // No workout route
                completion(nil, nil, true)
                return
            }
            var routeLocations: [CLLocation] = []
            
            // Query for first workout route of workout
            let workoutRouteLocationsQuery = HKWorkoutRouteQuery(route: workoutRoutes.first!) { (routeQuery, locations, done, error) in
                if error != nil {
                    self.healthStore.stop(routeQuery)
                    completion(nil, nil, true)
                    return
                }
                routeLocations.append(contentsOf: locations!)
                
                // If this is the final batch
                if done {
                    if routeLocations.count <= 1 {
                        completion(nil, nil, true)
                    } else {
                        // Format locations
                        let formattedLocations = self.formatLocations(locations: routeLocations)
                        completion(routeLocations, formattedLocations, false)
                    }
                }
            }
            self.healthStore.execute(workoutRouteLocationsQuery)
        }
        healthStore.execute(workoutRouteQuery)
    }
    
    // Format locations from CLLocation to CLLocationCoordinate2D
    private func formatLocations(locations: [CLLocation]) -> [CLLocationCoordinate2D] {
        var formattedLocations: [CLLocationCoordinate2D] = []
        
        for location in locations {
            let newLocation = CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            formattedLocations.append(newLocation)
        }
        return formattedLocations
    }
}
