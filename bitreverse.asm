section .bss         ;ոչ սահմանված փոփոխականների համար սեկցիա
    num1 resb 12     ;12 սիմվոլանոց բուֆֆեր ինտ տիպի համար է,որից 2֊ը նշանի և ՛\0՛
    num2 resb 12     ;քանի որ ներմուծում ենք 2 թիվ բազմապատկելու համար,ապա 2-րդ բուֆֆեր ևս
    result resd 0    ;բազմապատկման արդյունքը պահպանելու համար փոփոխական,որը օգտագործվելու է շրջելու համար

section .text        ;հիմնական կոդի սեկցիա
    global _start    ;սահմանում ենք ծրագրի սկվելու պիտակը գլոբալ,որպեսզի linker֊ը տեսնի այն
_start:
    ;կատարվող կոդը սկսվում է այստեղ

    ;num1 input
    mov eax, 3       ;ՕՀ֊ի համար լինուքսում 3 թիվը կախված կոնտեքստից նաև կարդալու(read) կոդն է
    mov ebx, 0       ;stdin ստեղնաշարից թիվ ներմուծելու համար․0֊ն նշանակում է ստեղնաշարից կարդալ
    mov ecx, num1    ;առաջին թվի համար բուֆֆերն ենք նշում
    mov edx, 5       ;քանի որ ինտ տիպի է ամենաշատը 5 բայթ ներառելով նաև նշանը
    int 0x80         ;միջուկի կանչ

    ;num2 input
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 10
    int 0x80

    ;ազատում ենք ռեգիստրները ցիկլի համար
    xor ebx, ebx     ;արդյունքի համար
    xor ecx, ecx     ;ցիկլի քայլի համար

    mov ecx, num1    ;1֊ին թվի հասցեն
    mov edx,10

convert_num1:
    movzx esi,byte [ecx];տվյալ սիմվոլը
    cmp esi,0        ;ստուգում ենք տողի վերջը
    je convert_num1_done;եթե այո,ապա ավարտ
    sub esi,'0'      ;ըստ ASCII-ի թվի սիմվոլը ստանալու համար հանում ենք 0 սիմոլի արժեքը ստանալով տարբերությունը որպես արժեք
    imul eax,edx     ;ձախ տեղաշարժ բազմապատկելով 10
    add eax,esi      ;տվյալ թիվը ավելացնում ենք ընդհանուրին
    inc ecx          ;ինկրեմենտ դեպի հաջորդ սիմվոլ
    jmp convert_num1 ;կրկնում ենք նույն էտապները մինչև վերջ num1֊ի համար
convert_num1_done:
    xor ebx, ebx
    mov ecx, num2

convert_num2:
    movzx esi, byte [ecx]
    cmp esi, 0
    je multiply      ;եթե վերջն է բազմապատկում ենք
    sub esi, '0'
    imul ebx, edx
    add ebx, esi
    inc ecx
    jmp convert_num2

multiply:
    imul eax,ebx
    mov [result],eax

    mov eax, [result]

    xor ecx,ecx
    xor ebx,ebx

reverse_bits:
    shl ebx, 1       ;ձախ տեղաշարժ
    test eax, 1      ;ստուգւմ ենք կրտսեր բիթը
    adc ebx, 0       ;եթե բիթը տեղադրված է ավելացնում ենք EBX֊ին
    shr eax,1        ;աջ տեղաշարժ
    inc ecx          ;բիթերի հաշվիչի ինկրեմենտ
    cmp ecx,32       ;ստուգւմ ենք անցել ենք արդյոք բոլոր բիթերով
    jl reverse_bits  ;եթե ոչ,ապա շարունակում ենք

    mov [result],ebx ;արդյունքը պահպանում ենք
    mov eax,[result] ;ժամանակավորապես օգտագործելու համար

    add eax,'0'      ;դարձնում ենք սիմվոլ
    mov [num1],eax   ;պահպանում ենք բուֆֆերում տպելու համար

    mov eax,4        ;համակարգի write կանչ
    mov ebx,1        ;stdout
    mov ecx,num1     ;արդյունքի հասցեն
    mov edx,1        ;1 բայթ
    int 0x80

    mov eax,1        ;exit
    xor ebx,ebx      ;return 0
    int 0x80
