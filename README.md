1. **An overview of the purpose of the project**  
We implement the game Sudoko including:
    - A solver
    - A board generator
    - A command-line interface client to play the game
        - A hint system 
        - Functionality to save and load boards  

    If time permits we might also include more sudoko variants, a highscore system, and a web client. These variants might include "killer sudoko", "baby-sudoko (4x4)" etc.



2. **A list of libraries you plan on using**
    - **Additionally if any of the libraries are either not listed above or are in the data processing category above, you will also be required to have successfully installed the library on all team member computers and have a small demo app working to verify the library really works. We require this because OCaml libraries can be flakey. You will need to submit this demo/ as part of the code submission for your design.**  
    
    - _yojson_ to serialize/deserialize our sudoku board. 
    - _stdio_ for doing the command-line interface. 




3. **Commented module type declarations (.mli files) which will provide you with an initial specification to code to**
    - **You can obviously change this later and don’t need every single detail filled out**
    - **But, do include an initial pass at key types and functions needed and a brief comment if the meaning of a function is not clear.**

    See _Lib.mli_. 


4. **Include a mock of a use of your application, along the lines of the Minesweeper example above but showing the complete protocol.**

    ``` 
    $ ./sudoku.exe init  
    
    
    
    ```
5. **Also include a brief list of what order you will implement features.**
    1. Initially we will work on our Sududo library that is the interface for updating and generating sudoku boards.
    2. Add tests to ensure everything works as expected. 
    3. 



6. **If your project is an OCaml version of some other app in another language or a projust you did in another course etc please cite this other project. In general any code that inspired your code needs to be cited in your submissions.**  
    _None_

7. **You may also include any other information which will make it easier to understand your project.**  
    See [Wikipedia](https://en.wikipedia.org/wiki/Sudoku)