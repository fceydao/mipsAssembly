.data
 prompt: .asciiz "Enter a number between 1 and 10: " #Kullanıcıdan sayı istenmesi
 invalid: .asciiz "Invalid number. Please try again.\n" #Geçersiz girişte hata mesajı verilmesi
 resultLabel: .asciiz "Result: " 
 inputStr: .space 11 #10 karakter + girişin sonunu işaretleyen null karakter alanı ayrılması
 prompt_chars: .asciiz "Enter 10 characters: \n" #10 karakterlik bir string girişi istenmesi
 reverse_message: .asciiz "Dizinin içeriğinin ters sıralanmış hali: \n"
 school_ids: .asciiz "-1306210023\n-1306210021\n-1306200076\n-1306200027\n1306210132\n" 
.text
.globl main
main:
 li $v0, 4 #syscall: print string
 la $a0, prompt #Kullanıcıya bir sayı girmesini isteyen mesajın adresinin yüklenmesi
 syscall #Mesajın ekrana basılması
 li $v0, 5 #syscall: read integer
 syscall #Kullanıcının girdiği tam sayının alınması
 move $t0, $v0 # store number in $t0 #Girilen sayının $t0 register'ına kopyalanması
 blt $t0, 1, invalid_input #Sayı 1'den küçükse invalid_input etiketine atlanması
 bgt $t0, 10, invalid_input #Sayı 10'dan büyükse invalid_input etiketine atlanması
 beq $t0, 10, handle_school_ids #Sayı 10 ise handle_school_ids etiketine atlanması
17
 ble $t0, 6, handle_function_f #1-6 arası sayılarda handle_function_f etiketine atlanması
 blt $t0, 10, handle_reverse_string #7-9 arası girişte handle_reverse_string etiketine atlanması
invalid_input:
 li $v0, 4 #syscall: print string
 la $a0, invalid #Geçersiz giriş mesajının adresinin yüklenmesi
 syscall #Mesajın ekrana basılması
 j main #main etiketine geri dönülmesi
handle_function_f:
 li $v0, 4
 la $a0, resultLabel
 syscall
 move $a0, $t0 #İşlem yapılacak sayının $a0 register'ına kopyalanması
 jal compute_f #compute_f fonksiyonunun çağrılması
 move $a1, $v0 #compute_f fonksiyonundan dönen sonucun $a1 register'ına kopyalanması
 li $v0, 1
 move $a0, $a1 #Sonucu ekrana basmak için $a0 register'ının kullanılması
 syscall
 j end
handle_reverse_string:
 #String girişini ters çevirip ekrana yazan metodun yazılması
 li $v0, 4
 la $a0, prompt_chars #String girişi isteyen mesajın adresinin yüklenmesi
 syscall
18
 li $v0, 8
 la $a0, inputStr #Girişi almak için bir buffer adresinin yüklenmesi
 li $a1, 11 #Dizinin maksimum giriş uzunluğunun 11 olarak belirlenmesi
 syscall
 li $v0, 4
 la $a0, reverse_message #Tersine çevrilmiş string başlığı mesajının adresinin yüklenmesi
 syscall
 li $t1, 10
reverse_loop:
 addi $t1, $t1, -1
 bltz $t1, end_reverse
 lb $a0, inputStr($t1) #inputStr içindeki belirli bir karakterin yüklenmesi
 li $v0, 11 #syscall: print character
 syscall
 j reverse_loop
end_reverse:
 j end
handle_school_ids:
 li $v0, 4
 la $a0, school_ids #Okul kimlik numaralarını içeren mesajın adresinin yüklenmesi
 syscall
 j end
end:
 li $v0, 10 #syscall: exit
19
 syscall
compute_f:
 li $v0, 10 #İşlem sonucunun depolanması için bir register seçilmesi
 blt $a0, 3, compute_f_exit #Sonuç 3'ten küçükse fonksiyonun sonlandırılması
 addi $sp, $sp, -8 #Çağrı yığını için yer ayrılması
 sw $ra, 4($sp) #return address'inin yığına kaydedilmesi
 sw $a0, 0($sp) #Gelen parametrenin yığına kaydedilmesi
 addi $a0, $a0, -1 #Gelen parametrenin bir azaltılması
 jal compute_f #compute_f fonksiyonunun tekrar çağrılması
 lw $t2, 0($sp) #Kaydedilen parametrenin geri yüklenmesi
 move $t1, $v0 #compute_f’ten dönen sonucun başka bir register'a kopyalanması 
 
 mul $v0, $t2, $t1 #Sonucun hesaplanması
 mul $v0, $v0, 2 #Sonucun ikiyle çarpılması
 lw $ra, 4($sp) #return address'in yığından geri yüklenmesi
 addi $sp, $sp, 8 #Yığından çıkarılması
 jr $ra #Çağrı yapan yere dönülmesi
compute_f_exit:
 jr $ra