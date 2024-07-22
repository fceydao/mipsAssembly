.data
 prompt: .asciiz "Enter a number between 1 and 10: " # Kullanıcıdan sayı istenmesi (Prompt the user to enter a number)
 invalid: .asciiz "Invalid number. Please try again.\n" # Geçersiz girişte hata mesajı verilmesi (Display error message for invalid input)
 resultLabel: .asciiz "Result: " 
 inputStr: .space 11 # 10 karakter + girişin sonunu işaretleyen null karakter alanı ayrılması (Allocate space for 10 characters + null terminator)
 prompt_chars: .asciiz "Enter 10 characters: \n" # 10 karakterlik bir string girişi istenmesi (Prompt for a string of 10 characters)
 reverse_message: .asciiz "Dizinin içeriğinin ters sıralanmış hali: \n" # Tersine çevrilmiş string başlığı mesajının yüklenmesi (Message for reversed string)
 school_ids: .asciiz "-1306210023\n-1306210021\n-1306200076\n-1306200027\n1306210132\n" # Okul kimlik numaralarını içeren mesajın adresinin yüklenmesi (List of school IDs to be displayed)

.text
.globl main
main:
 li $v0, 4 # syscall: print string
 la $a0, prompt # Kullanıcıya bir sayı girmesini isteyen mesajın adresinin yüklenmesi (Load address of the prompt message)
 syscall # Mesajın ekrana basılması (Print the message to the screen)
 li $v0, 5 # syscall: read integer
 syscall # Kullanıcının girdiği tam sayının alınması (Read the integer input from the user)
 move $t0, $v0 # store number in $t0 (Girilen sayının $t0 register'ına kopyalanması)
 blt $t0, 1, invalid_input # Sayı 1'den küçükse invalid_input etiketine atlanması (If the number is less than 1, jump to invalid_input)
 bgt $t0, 10, invalid_input # Sayı 10'dan büyükse invalid_input etiketine atlanması (If the number is greater than 10, jump to invalid_input)
 beq $t0, 10, handle_school_ids # Sayı 10 ise handle_school_ids etiketine atlanması (If the number is 10, jump to handle_school_ids)
 ble $t0, 6, handle_function_f # 1-6 arası sayılarda handle_function_f etiketine atlanması (If the number is between 1 and 6, jump to handle_function_f)
 blt $t0, 10, handle_reverse_string # 7-9 arası girişte handle_reverse_string etiketine atlanması (If the number is between 7 and 9, jump to handle_reverse_string)

invalid_input:
 li $v0, 4 # syscall: print string
 la $a0, invalid # Geçersiz giriş mesajının adresinin yüklenmesi (Load address of the invalid input message)
 syscall # Mesajın ekrana basılması (Print the message to the screen)
 j main # main etiketine geri dönülmesi (Jump back to main to prompt the user again)

handle_function_f:
 li $v0, 4 # syscall: print string
 la $a0, resultLabel # Sonuç etiketinin adresinin yüklenmesi (Load address of the result label)
 syscall # Sonuç etiketinin ekrana basılması (Print the result label)
 move $a0, $t0 # İşlem yapılacak sayının $a0 register'ına kopyalanması (Copy the number to $a0 for computation)
 jal compute_f # compute_f fonksiyonunun çağrılması (Call the compute_f function)
 move $a1, $v0 # compute_f fonksiyonundan dönen sonucun $a1 register'ına kopyalanması (Copy the result from compute_f to $a1)
 li $v0, 1 # syscall: print integer
 move $a0, $a1 # Sonucu ekrana basmak için $a0 register'ının kullanılması (Use $a0 to print the result)
 syscall # Sonuç ekrana basılması (Print the result)
 j end # end etiketine atlanması (Jump to end)

handle_reverse_string:
 # String girişini ters çevirip ekrana yazan metodun yazılması (Method to reverse and print the entered string)
 li $v0, 4 # syscall: print string
 la $a0, prompt_chars # String girişi isteyen mesajın adresinin yüklenmesi (Load address of the prompt for string input)
 syscall # Mesajın ekrana basılması (Print the message to the screen)
 li $v0, 8 # syscall: read string
 la $a0, inputStr # Girişi almak için bir buffer adresinin yüklenmesi (Load buffer address for input)
 li $a1, 11 # Dizinin maksimum giriş uzunluğunun 11 olarak belirlenmesi (Set maximum input length to 11)
 syscall # String girişinin alınması (Read the string input)
 li $v0, 4 # syscall: print string
 la $a0, reverse_message # Tersine çevrilmiş string başlığı mesajının adresinin yüklenmesi (Load address of the reversed string message)
 syscall # Mesajın ekrana basılması (Print the message to the screen)
 li $t1, 10 # Set $t1 to 10 for reverse loop
reverse_loop:
 addi $t1, $t1, -1 # Decrease $t1
 bltz $t1, end_reverse # Eğer $t1 sıfırdan küçükse end_reverse etiketine atlanması (If $t1 is less than 0, jump to end_reverse)
 lb $a0, inputStr($t1) # inputStr içindeki belirli bir karakterin yüklenmesi (Load a character from inputStr)
 li $v0, 11 # syscall: print character
 syscall # Karakterin ekrana basılması (Print the character)
 j reverse_loop # reverse_loop etiketine atlanması (Jump back to reverse_loop)

end_reverse:
 j end # end etiketine atlanması (Jump to end)

handle_school_ids:
 li $v0, 4 # syscall: print string
 la $a0, school_ids # Okul kimlik numaralarını içeren mesajın adresinin yüklenmesi (Load address of the school IDs message)
 syscall # Mesajın ekrana basılması (Print the message to the screen)
 j end # end etiketine atlanması (Jump to end)

end:
 li $v0, 10 # syscall: exit
 syscall # Programın sonlandırılması (Exit the program)

compute_f:
 li $v0, 10 # İşlem sonucunun depolanması için bir register seçilmesi (Choose a register to store the result of computation)
 blt $a0, 3, compute_f_exit # Eğer sonuç 3'ten küçükse fonksiyonun sonlandırılması (If the result is less than 3, exit the function)
 addi $sp, $sp, -8 # Çağrı yığını için yer ayrılması (Allocate space on the stack for call)
 sw $ra, 4($sp) # Return address'inin yığına kaydedilmesi (Save return address on the stack)
 sw $a0, 0($sp) # Gelen parametrenin yığına kaydedilmesi (Save the parameter on the stack)
 addi $a0, $a0, -1 # Gelen parametrenin bir azaltılması (Decrement the parameter)
 jal compute_f # compute_f fonksiyonunun tekrar çağrılması (Recursively call compute_f)
 lw $t2, 0($sp) # Kaydedilen parametrenin geri yüklenmesi (Restore the saved parameter)
 move $t1, $v0 # compute_f’ten dönen sonucun başka bir register'a kopyalanması (Copy the result from compute_f to another register)
 
 mul $v0, $t2, $t1 # Sonucun hesaplanması (Compute the result)
 mul $v0, $v0, 2 # Sonucun ikiyle çarpılması (Multiply the result by 2)
 lw $ra, 4($sp) # Return address'in yığından geri yüklenmesi (Restore the return address from the stack)
 addi $sp, $sp, 8 # Yığından çıkarılması (Deallocate stack space)
 jr $ra # Çağrı yapan yere dönülmesi (Return to caller)

compute_f_exit:
 jr $ra # Çağrı yapan yere dönülmesi (Return to caller)
