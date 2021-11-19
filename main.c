/*
A)  Vetor com 40 posições, andar de 4 em 4.
    Inserir números da solução 1 a 1. 

B)  Funcao que sorteia 4 cores dentro das 6 discponiveis( blue B, green G, red R, yellow Y, white W, orange O).

C)  Funcao para ler a combinação inserida e funcao para validar  a  inserção.
    Caso esta sequência não seja válida, o programa irá solicitar ao utilizador uma nova combinação.

D)  Após cada jogada será impresso na consola o estado do atual tabuleiro.

E)  Usar funcao de ler a combinaçao para validar o número de cores corretas numa posição certa, e o número de cores corretas nas posições erradas. 

F)  Funcao fim de jogo. |*

G)  Funcao de pontos (ver pdf projeto). |*

H/I)Para a funcao fim de jogo (ver pdf projeto). |*
*/

#include "main.h"

int count_jogada = 0;
char tabuleiro[40];
int tabuleiro_2[20];
char combinacao[6];
char insercao[4];
int pontuacao = 0;
int countR = 0;
int countW = 0;

int main() {
    jogo();
    
    return 0;
}

void sorteia() {
    int j, temp, num;
    time_t t;
    srand((unsigned)time (&t));

    for (int i = 0; i < 4; i++) {
        num = rand() % 6;
        switch (num) {
            case 0:
                combinacao[i] = 'B';
                break;
            case 1:
                combinacao[i] = 'G';
                break;
            case 2:
                combinacao[i] = 'R';
                break;
            case 3:
                combinacao[i] = 'Y';
                break;
            case 4:
                combinacao[i] = 'W';
                break;
            case 5:
                combinacao[i] = 'O';
        }
        //printf("%c", combinacao[i]);
    }
}
void ler_sequencia() {
    printf("\nblue B, green G, red R, yellow Y, white W, orange O\n");
    printf("Insert the sequence in up EX: BRWO\n");
    scanf(" %s",insercao);
}
int ver_sequencia(char sequencia[4]) {
    int count = 0;

    for (int i = 0; i < 4; i++) {
        if(sequencia[i] == 'B' || sequencia[i] == 'G' || sequencia[i] == 'R' || sequencia[i] == 'Y' || sequencia[i] == 'W' || sequencia[i] == 'O')
            count++;
    }
    if(count == 4)
        return 0;
    return 1;
}
void comparar_sequencia(char sequencia[4], char chave[4]) {
    int a[4] = {-1, -1, -1, -1};
    countR = 0;
    countW = 0;

    for (int i = 0; i < 4; i++) {
        if(chave[i] == sequencia[i]) {
            a[i] = i;
            countR++;
        }
    }

    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            if(i == a[i])
                break;
            if(chave[i] == sequencia[j] && j != a[j]) {
                a[i] = j;
                countW++;
                break;
            }
        }
    }
    tabuleiro_2[count_jogada * 2] = countR;
    tabuleiro_2[(count_jogada * 2) + 1] = countW;
}
void imprimir_tabuleiro() {
    for (int i = 1; i < count_jogada + 1; i++) {
        for (int j = 0; j < 4 ; j++) {
            tabuleiro[(count_jogada * 4) + j] = insercao[j];
            printf("%c",tabuleiro[(i * 4) + j]);
        }      
        printf("|R-%d|W-%d\n",tabuleiro_2[i * 2],tabuleiro_2[(i * 2) + 1]);
    }
}
int fim_de_jogo(int count) {
    if (count == 10) {
        printf("\nGAME OVER!! || KEY -> %s\n", combinacao); 
        pontuacao = pontuacao - 3;
        pontuacao = pontuacao + (countR * 3);
        if (pontuacao < 0) {
            pontuacao = 0;
        } 
        return 1;
    } 
    else if (tabuleiro_2[count * 2] == 4) {
        printf("\nYOU WON!! || KEY -> %s\n", combinacao);
        pontuacao = pontuacao + 12;
        return 1;
    } 
    count_jogada++;
    return 0;
}
void jogo() {
    char a = ' ';
    sorteia(); 

    while (fim_de_jogo(count_jogada) == 0) {    
        ler_sequencia();
        while (ver_sequencia(insercao)) {
            printf("Insert a correct sequence\n\n");
            ler_sequencia();
        } 
        printf("\n");

        comparar_sequencia(insercao, combinacao);
        imprimir_tabuleiro();
    }
    
    while (a != 'e') {
        printf("\n\t\t\t\t-----> Vew Points: PRESS p, End Game: PRESS e, Restar Game: r <-----\n");
        scanf(" %c",&a);

        if (a == 'p') {
            printf("Score: %d\n", pontuacao);
            continue;
        }
        else if (a == 'r') {
            count_jogada = 0;
            jogo();
            break;
        }     
    }
}