;8. Dându-se un octet mod si douã siruri s1 si s2 (având aceeasi lungime n), sã se construiascã sirul s3 în felul urmãtor:
;- daca mod apartine [00h,0Fh] atunci s3[i]:=s1[i]+s2[i] (i=1,n)
;- daca mod apartine [10h,1fh] atunci s3[i]:=abs(s1[i]-s2[i])
;- daca mod apartine [20h,2fh] atunci s3:=s1+s2 (+ reprezintã concatenarea)
;- daca mod apartine [30h,3fh] atunci s3[i]:=s1[i]+s2[n-i] 
;- daca mod apartine [40h,4Fh] atunci s3:=~s1+~s2 (unde ~ reprezintã sirul parcurs în ordine inversã)
;- altfel s3:=s1.

assume cs:code,ds:data

data segment
	s1 db 2, 4, 3, 6, 7, 8 ;sirul initial s1  
	lungime equ $-s1      ;in lungime avem dimensiunea sirurilor
	s2 db 7, 1, 5, 2, 6 ,3 ;sirul initial s2
	s3 db 2*lungime dup(?) ;sirul rezultat care are dimensiune 2*lungime
	modd db 12 ;modd reprezinta mod-ul din enunt
data ends

code segment
start:
	mov ax, data
	mov ds, ax
	
	mov cx, lungime ;in cx avem lungime loop-ului
	jcxz Finala		
	mov si, 0
	mov al, modd ;al=modd
	cmp al,4fh ;comparam modd cu 4fh
	ja cer6a   ;daca al>4fh elementul nu apartine niciunui interval si se sare la cer6a
	cmp al,3fh ;comparam modd cu 3fh
	ja cer5    ;daca al>3fh => al apartine [40h,4fh], se sare la cer5
	cmp al,2fh ;comparam modd cu 2fh
	ja cer4    ;daca al>2fh => al apartine [30h,3fh], se sare la cer4
	cmp al,1fh ;comparam modd cu 1fh
	ja cer3	;daca al>1fh => al apartine [20h,2fh], se sare la cer3
	cmp al,0fh ;comparam modd cu 0fh
	ja cer2		;daca al>0fh => al apartine [10h,1fh], se sare la cer2

cer1:   ;Daca nu satisface nicio conditi de mai sus => modd apartine [00h,0fh]
	mov al, s1[si] 
	mov bl, s2[si]
	add al, bl
	mov s3[si], al	;s3[si]:=s1[si]+s2[si]
	inc si		;si:=si+1
	loop cer1
	jmp Final

cer2:
	mov al, s1[si]
	mov bl, s2[si]
	sub al, bl	;al:=s1[si]-s2[si]
	cmp al, 0	;comparam pe al cu 0
	jge adpoz	;daca al>0 => diferenta este un numar pozitiv si trecem la adpoz
	neg al		;daca numarul este negativ atunci ii schimbam semnul
adpoz:  
	mov s3[si], al	;s3[si]:=abs(s1[si]-s2[si])
	inc si
	loop cer2
	jmp Final
	

Finala:
	jmp Final 
cer6a:
	jmp cer6
	
	
cer3:
	mov al, s1[si]
	mov bl, s2[si]
	mov s3[si+lungime], bl ;s3[si+lungime]:=s2[si]
	mov s3[si], al			;s3[si]:=s1[si]
	inc si
	loop cer3
	jmp Final

cer4:
	mov di,lungime-1  ;di=lungime-1 pentru a putea accesa ultimul element al sirului s2
cer4b:
	mov al, s1[si]
	mov bl, s2[di]
	add al, bl
	mov s3[si], al	  ;s3[i]:=s1[i]+s2[n-i]
	dec di			  ;di:=di-1
	inc si			  ;si:=si+1
	loop cer4b
	jmp Final

cer5:
	mov di, lungime-1
cer5b:
	mov al, s1[si]
	mov bl, s2[si]
	mov s3[di+lungime], bl	;s3[di+lungime]=s2[si]
	mov s3[di],al			;s3[di]=s1[si]
	inc si
	dec di
	loop cer5b
	jmp Final

cer6:
	mov al, s1[si]
	mov s3[si], al ;s3[si]:=s1[si]
	inc si
	loop cer6

	
Final:
	mov ax, 4c00h
	int 21h

code ends
end start