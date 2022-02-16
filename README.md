# Expression evaluation in NASM x86
### Information
Here we evaluate an expression using 3 mutually recursive functions, which will evaluate an expression received as a parameter:

 - `expression(char *p, int *i)` - evaluates expressions such as `term + term` or `term - term`
 - `term(char *p, int *i)` - evaluates expressions such as `factor * factor` or `factor / factor`
 - `factor(char *p, int *i)` - evaluates expressions of the type `(expression)` or `number`, where number is a sequence of digits
### Specifications
 - `p` is the string
 - `i` is the current position in the string (it will be updated in functions)
 - numbers must be positive integers, but negative numbers may appear after operations
 - the divisions must be made between `int` numbers
 - the results fall into the `int` type
 - sent expressions must be syntactically correct
 - only round brackets are accepted
 In the test files all the specifications are followed
 
 ### Running and testing
 
 - `./check.sh` - will run all tests from `tests/in` will write the output to `tests/out` and will compare the results with `tests/ref`
 - `make && ./checker < tests/in/$(test_nr).in` will send the expression from the test file for evaluation and display it on `stdout`

### Implementation
The functions expression and term are in fact the same, they differ only by the operation that performs it. At first, these functions call their function superior (**expression** - **term**, and **term** - **factor**). After returning from the higher position, it is checked if the current position is the operation specific to the position in which it is located. If yes then we call the higher function again, and we add the result to the previous result obtained (for example, 3 + 4 + 5, it will make 3 + 4 first, then 7 + 5, where the previous result is first 3, then 7). Why is this done in a loop? Because we can have 3 + 4 + 5 * 7 * (5 * 5). The most interesting thing happens in the factor, where the conversion from string to `int` is done. First of all we see what character is in the current position. If it is "(" then we increase the position and call **expression**. After returning from the **expression** we will always be in closed parenthesis, so we need to advance again, and after returning to what **expression** gave us. If it is not parenthesis, it means that is a digit, which is the beginning of a number, so we need to convert. In the **eax** we will save the number, because later we have to return it. How do I extract the number? For example we have "777", I will start with 0 * 10 + 7, then 7 * 10 + 7, 77 * 10 + 7, where 0, 7, 77 is the **eax**. When the current position is anything but the number, we extract the factor, so we can get out of **factor**. 
*The equivalent of the code in asm is in the checker.c*.
