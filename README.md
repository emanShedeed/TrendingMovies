# TrendingMovies
this is an iOS application that displays the next
● A list of trending movies
○ The list should support pagination
○ Movie item contains at least

■ Title

■ Image

■ The year of release date

○ This screen should have a search control to filter
movies locally

○ Add filter chips to filter locally by genres of movies
and if no selected item, you should display all items


● A Movie details (when the user clicks on a movie item
from the previous list)

○ The details screen contains at least

■ Title

■ Image

■ The year and the month of release date

■ Genres

■ Overview

■ Homepage

■ Budget

■ Revenue

■ Spoken Languages

■ Status

# Major points:

1. I have implemented clean code, modularization, dependency injection, dependency inversion, separation of concerns, and all the SOLID principles.

2. I have used MVVM-C with RXSwift as the design pattern. 
3. The application works in both online and offline modes. It checks if the data exists locally, fetches it if it does, and fetches it from the online repository if it doesn't. Then, it stores it locally. Also, I have implemented the search functionality using genre and/or search text fields for more accuracy.

4. I have added a small example of the unit test part, but it is not fully complete yet, I will work on it once I have more time.


