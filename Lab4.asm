;8. Sa se scrie un program care citeste numele unui fisier si doua caractere de la tastatura.
;Programul va inlocui in fisier toate aparitiile primului caracter cu cel de-al doilea caracter.
assume cs:code,ds:data 

data segment
	car1 db ?
	car2 db ?
	cfisier db ?
	handler dw ?
	linienoua db 10,13,'$'
	numefisier db 20,21 dup (?)
	car1mesaj db 'Dati primul caracter: $'
	car2mesaj db 'Dati al doilea caracter: $'
	fisiermesaj db 'Dati numele fisierului: $'
	eroaremesaj db 'Programul are erori: $'
data ends

code segment
start:
	mov ax,data
	mov ds,ax
	
	;afisam pe ecran car1mesaj
	;intrerupere pentru afisarea unui si de caractere
	mov ah,09h 
	mov dx,offset car1mesaj ;punem in dx
	int 21h
	
	;citim primul caracter
	;intrerupere pentru citirea unui caracter cu ecou
	mov ah,01h 
	int 21h
	mov car1,al ;punem in car1 caracterul citit care se afla in al
	
	;linie noua
	;intrerupere pentru afisarea unui si de caractere
	mov ah,09
	mov dx,offset linienoua
	int 21h
	
	;afisam pe ecran car2mesaj
	;intrerupere pentru afisarea unui si de caractere
	mov ah,09h 
	mov dx,offset car1mesaj ;punem in dx
	int 21h
	
	;citim al doilea caracter
	;intrerupere pentru citirea unui caracter cu ecou
	mov ah,01h
	int 21h
	mov car2,al ;punem in car2 caracterul citit care se afla in al
	
	;linie noua
	;intrerupere pentru afisarea unui si de caractere
	mov ah,09
	mov dx,offset linienoua
	int 21h
	
	;afisare pe ecran fisiermesaj
	;intrerupere pentru afisarea unui si de caractere
	mov ah,09
	mov dx,offset fisiermesaj
	int 21h
	
	;citim numele fisierului
	;intrerupere pentru citirea unui sir de caractere pana la apasarea tastei ENTER
	mov ah,0Ah
	mov dx,offset numefisier
	int 21h
	
	;linie noua
	;intrerupere pentru afisarea unui si de caractere
	mov ah,09
	mov dx,offset linienoua
	int 21h
	
	;transformam numele fisierului in cod ASCIZZ prin mutarea lui 0 dupa numele fisierului
	mov bl,numefisier[1] ;punem in bl lungimea numelui fisierului citit
	mov bh,0
	mov numefisier[bx+2],0 ;punerea lui 0 la sfarsitul numelui fisierului
	
	;deschidem fisierul
	;intrerupere de citire din fisier specificat prin identificatorul sau
	mov ah,3Dh
	mov al,2 ;deshidere pentru citire si scriere
	mov dx,offset numefisier[2]
	int 21h
	jc erori ;verificam daca sunt erori de citire prin verificare valorii carry flag-ului
			 ;daca carry flag are valoare 1 atunci programul a intampinat erori si se sare la erori
	
	;mutare handler-ul  fisier in hendler
	mov handler,ax
	mov bx,handler

	mov si,0
	;citirea a cate un caracter din fisier
	repeta:
	;intrerupere de citire din fisier specificat prin identificatorul sau
	mov ah,3fh
	mov dx,offset cfisier;punem dx dimensiunea maxima a lui cfisier
	mov cx,1;punem in cx numarul de caractere pe care dorim sa le citim
	int 21h
	jc erori 
	cmp ax,0 ;comparam ax cu 0,in cazul in care sunt egale inseamna ca am ajuns la sfarsitul fisierului
	jne compara ;daca nu sunt egale sarim la eticheta compara
	mov si,1
	
	compara:
	mov cl,cfisier
	cmp cl,car1 ;comparam caracterul citit din fisier cu primul caracter citit de la tastatura
	je schimba ;daca sunt egale le schimbam
	jmp urmator ;salt la urmator
	
	schimba:
	;trecem la pozitia caracterului car1 gasit in fisier
	;intrerupere de mutare a cursorului prin fisier
	mov ah,42h
	mov bx,handler
	mov cx,-1 ;maximul bitilor de mutat
	mov dx,-1 ;minimul bitilor de mutat 
	mov al,1 ;mutarea cursorului la pozitia actuala
	int 21h
	jc erori
	
	;shimbam caeacterul din fisier cu car2
	mov ah,40h
	mov bx,handler
	mov cx,1
	mov dx,offset car2 ;punem in dx lungimea car2
	int 21h
	jc erori
	
	urmator:
	cmp si,1 ;comparam pe si cu 1 pt a vedea daca am ajuns la sfarsitul fisierului
	jne repeta ;daca nu sunt egale sare la repeta
	jmp sfarsit ;altfel sare la sfarsit
	
	erori:
	;afisam un mesaj pentru intalnirea unei erori
	mov ah,09h
	mov dx,offset eroaremesaj
	int 21h
	
	sfarsit:
	mov ax,4c00h
	int 21h
code ends
end start
