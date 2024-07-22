# MIPS Assembly Program

## Description

This MIPS assembly program is designed to perform various tasks based on user input. The program provides the following functionalities:

1. **Prompt for a Number**: The user is asked to enter a number between 1 and 10.
2. **Handle Invalid Input**: If the number entered is outside the valid range, an error message is displayed.
3. **Compute Function F**: For numbers between 1 and 6, a computation function (`compute_f`) is called.
4. **Reverse a String**: For numbers between 7 and 9, the program prompts the user to enter a string of 10 characters and displays the reversed string.
5. **Display School IDs**: If the number 10 is entered, a list of school IDs is displayed.

## Program Structure

### Data Section

- `prompt`: Message asking the user to enter a number.
- `invalid`: Error message for invalid input.
- `resultLabel`: Label for the result of computation.
- `inputStr`: Space reserved for user input (10 characters + null terminator).
- `prompt_chars`: Message asking the user to enter 10 characters.
- `reverse_message`: Message displaying the reversed string.
- `school_ids`: List of school IDs to be displayed.

### Text Section

#### Main Routine

1. Displays the prompt message asking for a number.
2. Reads the integer input from the user.
3. Checks if the number is between 1 and 10 and branches to the appropriate handling routine:
   - **Invalid Input**: Displays an error message and prompts the user to enter a number again.
   - **Function F**: Computes a result based on the input number and displays it.
   - **Reverse String**: Prompts the user to enter a string and displays the reversed string.
   - **School IDs**: Displays a list of predefined school IDs.

#### `compute_f` Function

- Recursively computes a result based on the input number. 
- Multiplies the result by 2 before returning it.

## How to Run

1. Assemble the code using a MIPS assembler.
2. Load the resulting executable into a MIPS simulator.
3. Run the program and follow the prompts.

## Example

1. Enter a number between 1 and 10.
2. Depending on the number:
   - If 1-6, the program will display the result of `compute_f`.
   - If 7-9, enter a 10-character string to see it reversed.
   - If 10, the program will display a list of school IDs.
   - If an invalid number is entered, the program will prompt again.

## Notes

- Ensure that the string entered for reversing is exactly 10 characters long.
- The `compute_f` function demonstrates basic recursion and arithmetic operations.
