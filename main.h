#ifndef PROJETOARQUITETURA_MAIN_H
#define PROJETOARQUITETURA_MAIN_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

int main();
void sorteia();
void ler_sequencia();
int ver_sequencia(char sequencia[4]);
void comparar_sequencia(char sequencia[4], char chave[4]);
void imprimir_tabuleiro();
int fim_de_jogo(int count);
void pontos_jogador(int n);
void jogo();

#endif //PROJETOARQUITETURA_MAIN_H