# iOS Technical Demo Project App

## ReadMe

**Disclaimer:** This project was developed using Swift 5.6.1.

### Brief

The brief was to develop an application allowing users to select their desired cat breed and view a list displaying cat pictures of the chosen breed.

### Objectives

My objective was to create an engaging application that provides users with images and information about various cat breeds. I recognized the importance of visually appealing content to keep users engaged. 

Upon studying the API, I observed the need for multiple requests to fetch cat information and images separately. To address this, I opted to implement the Repository Pattern. This approach facilitates fetching an array of breeds using a model type, followed by fetching image data for each breed. The goal was to ensure that as users scroll through the list of cat breeds, there would be accompanying images along with breed names and origins. 
I considered the balance between delivering an engaging user experience and the performance implications of multiple API calls for image retrieval. Leveraging Swift's concurrency model could optimize this process.

The Repository object serves as the application's data backbone.

To efficiently handle the asynchronous nature of fetching images for each breed, I utilized Async Await API with TaskGroup, this can be seen in the `addImage()` and `getBreedsImageURL()` functions.  
. Implementing UI loading views was crucial to notify users about ongoing image downloads.

For data caching, I implemented a lightweight and flexible caching mechanism. This decision was made to focus on core functionality while maintaining control over preventing data races and race conditions.

### MVVM Architecture

I adopted the MVVM architecture to decouple logic from views, enabling easier unit testing and avoiding tight coupling between logic and views. MVVM also facilitates cleaner dependency injection practices.

### Next Steps

Given more time, I would prioritize writing unit tests for core application logic, particularly focusing on the Cache and BreedRepository components. For example, testing the `getBreedsWithImages()` function is crucial as it handles fetching breeds and their images. I would mock the API and `allBreedCache` to return predefined data, ensuring that the method behaves as expected. Additionally, testing error handling scenarios, such as when the API or `allBreedCache` throws an error, is essential to guarantee robustness and reliability.


