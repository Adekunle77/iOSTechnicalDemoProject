# iOS Technical Demo Project App

## ReadMe

**Disclaimer:** This project was developed using Swift 5.6.1.

### Brief

The brief was to develop an application allowing users to select their desired cat breed and view a list displaying cat pictures of the chosen breed.

### Objectives

My objective was to create an engaging application that provides users with images and information about various cat breeds. I recognized the importance of visually appealing content to keep users engaged.  

###  Utilization of Repository Pattern
Upon studying the API, I observed the need for multiple requests to fetch cat information and images separately. To address this, I opted to implement the Repository Pattern.The decision to employ the Repository Pattern stems from a desire to promote separation of concerns and maintain a scalable architecture. By abstracting data access logic into a separate layer, I ensure loose coupling between the data sources and the rest of the application, facilitating easier testing and future modifications.

The Repository object acts as a centralized source for fetching the breed's information and images. It encapsulates the complexities of interacting with external APIs, providing a clean interface for the ViewModel layer to access data.

### Concurrency with Async Await API and TaskGroup
I used Async Await API with TaskGroup to enable the app to handle asynchronous operations in a concise and readable manner. With TaskGroup the app to handle multiple asynchronous tasks, such as fetching an array of breed images concurrently.

The `getImageURL(with url: String) async throws -> String` function demonstrates the usage of Async Await API with TaskGroup. This function asynchronously fetches image URLs for a given breed. It employs a dictionary (`fetchTasks`) to store ongoing image fetching tasks, ensuring efficient reuse of tasks and preventing redundant network calls

For data caching, I implemented a lightweight and flexible caching mechanism. This decision was made to focus on core functionality while maintaining control over preventing data races and race conditions.

### MVVM Architecture

I adopted the MVVM architecture to decouple logic from views, enabling the case for easy unit testing and avoiding tight coupling between logic and views. MVVM also facilitates cleaner dependency injection practices within the project.

### DIContainer 
By implementing a DIContainer in the project, I aimed to minimize the reliance of objects on concrete types, I like to avoid directly injecting dependencies into views because it could lead to complications, especially in terms of testing and separating concerns, by using DIContainer it will help to avoid that. Also Utilizing a DIContainer in this project allows for a more centralized approach to managing dependencies, keeping views cleaner and more focused on presentation logic.



### Function Explanation getImageURL(with url: String) async throws -> String
The `getImageURL(with url: String) async throws -> String` function serves the purpose of asynchronously fetching the image URL for a given breed. Here's a breakdown of its implementation:


      func getImageURL(with url: String) async throws -> String {  
        if let existingTask = fetchTasks[url] {
            return try await existingTask.value
        } else {
            let fetchTask = Task { [weak self] () -> String in
                guard let self = self else { throw EndpointError.apiInstanceDeallocated }
                let imageUrl: SelectedBreed = try await self.api.fetchData(endpoint: BreedsEndpoint.imageURL(url: url))
                return imageUrl.url
            }
            
            fetchTasks[url] = fetchTask
            
            do {
                let imageUrl = try await fetchTask.value
                fetchTasks[url] = nil
                return imageUrl
            } catch {
                fetchTasks[url] = nil
                throw error
            }
        }
    }`

- The function checks if there's an existing fetch task for the provided URL in the `fetchTasks` dictionary.
- If a task exists, it returns the cached image URL.
- If no task exists, a new Task is created to fetch the image URL asynchronously using the `api.fetchData(endpoint:)` method.
- The fetched image URL is then stored in the `fetchTasks` dictionary.
- Upon successful completion of the task, the image URL is returned, and the task is removed from the dictionary.
- If an error occurs during the task execution, the error is propagated up the call stack after cleaning up the associated task from the dictionary.

### Next Steps

Given more time, I would prioritize writing unit tests for core application logic, particularly focusing on the Cache and BreedRepository components. For example, testing the `getBreedsWithImages()` function is crucial as it handles fetching breeds and their images. I would mock the API and `allBreedCache` to return predefined data, ensuring that the method behaves as expected. Additionally, testing error handling scenarios, such as when the API or `allBreedCache` throws an error, is essential to guarantee robustness and reliability.
