<h1>Work Study Hours Tracker</h1>

<p> 
Ever had trouble determining how many Federal Work Study hours you have left? Probably not, because it's a niche issue. But I have, and it seemed like the perfect task to tackle with a program. This will track how many hours you've worked,
how many hours are left, and how much money you've made based on your alloted hours and wage.
</p>

<ul>
  <h2>Features</h2>
  <li>Create documents for each term</li>
  <li>File menu</li>
  <li>Rename/delete/open documents</li>
  <li>Data checking for proper input</li>
  <li>Sorting entries (To be implemented)</li>
  <li>Autosaving (In progress)</li>
</ul>

<ol>
  <h2>How to use:</h2>
  <li>File -> Create New Document</li>
  <li>Enter information</li>
  <li>Click the add hours button and enter the requested info</li>
</ol>

<br>
<p>
  This project is created entirely with Godot and GDScript. The main purpose of the project (while also being useful) is to help me learn how to write non-gaming applications. In this project, I decided
  to make use of many different autoload Managers that are accessible by any part of the code. A few notes:

  main.gd is, of course, the main handler of the project. It is the parent of the entire node structure and handles program execution (work is being done to clean this up currently).

  There are various Managers: 
  
    Window: Handles subwindow creation for various functions
    GUI: Handles the display of the UI
    File: Interfaces with files for opening, deleting, renaming, and passing files to whoever needs one
    Signal: Currently used to sync nodes at program execution so signals can be connected after nodes are _ready-ed
    Time Entry: Manages the main data type for the program including creating, deleting, and retrieving Time Entries

  Various parts of the scene tree have their own scripts also, such as the GUI sections, file menu, Time Entry resources, etc...

  This program is totally open-source and anyone is welcome to do what they wish with it, if for some reason you wish to do something with it. Any changes to the main program are subject to Gingham's approval, but fork away and have fun.
  
</p>
