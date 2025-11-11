# Dividir e Conquistar - Mediana das Medianas em CUDA (Uso de GPUs)

Este projeto implementa o algoritmo **Mediana das Medianas** utilizando **CUDA**, a plataforma de computação paralela da **NVIDIA** que permite executar código diretamente na **GPU** (placa de vídeo), a fim de aproveitar seu grande poder de processamento paralelo.
O objetivo é demonstrar como o **paralelismo massivo das GPUs** pode ser explorado para acelerar o cálculo da mediana em grandes conjuntos de dados, aplicando o paradigma de **Dividir e Conquistar** para maior eficiência e escalabilidade.


## Sobre o Algoritmo

A **Mediana das Medianas** é um algoritmo determinístico de seleção usado para encontrar a *k*-ésima menor (ou maior) estatística em um vetor de dados em tempo linear no pior caso, \( O(n) \).

Ele é baseado na ideia de dividir o vetor em pequenos grupos (5 elementos), calcular a mediana de cada grupo e então usar a mediana dessas medianas como pivô para particionar o vetor — o que garante uma boa escolha de pivô mesmo em casos desfavoráveis.

Nossa ideia é o desenvolvimento de uma estratégia paralelizada em **CUDA**, permitindo que várias medianas de grupos sejam calculadas simultaneamente por diferentes *threads* da GPU.


## Tecnologias Utilizadas

- [**CUDA**](https://developer.nvidia.com/cuda-toolkit) — para execução paralela em GPU
- [**C++**](https://isocpp.org/) — para execução sequencial
- [**LeetGPU**](https://leetgpu.com) — ambiente online usado para compilar e executar código CUDA sem necessidade de hardware físico NVIDIA


## Como Executar

### 1. Acesse o LeetGPU
Entre no site: [https://leetgpu.com](https://leetgpu.com)

### 2. Vá até o **Playground**
No menu superior, clique em **Playground** para abrir o ambiente interativo de código CUDA.

### 3. Cole o Código
Copie o conteúdo do arquivo `mom.cu` ou `mom.cpp` (fornecido neste repositório) e cole na área de edição do LeetGPU.

### 4. Selecione a GPU
Escolha um dos modelos de GPU disponíveis (por exemplo, “QV100” ou “RTX 3070”) — cabe lembrar que a escolha impacta apenas no desempenho.

### 5. Compile e Execute
Clique em **Run** ou use o atalho `Ctrl + Enter` para compilar e executar o código.
O terminal exibirá a saída do programa.


## Comparação: Código Serial (C++) x Paralelo (CUDA)

Para validar o ganho de desempenho com o uso de **CUDA**, o projeto também inclui uma versão **serial** implementada em **C++** (`mom.cpp`). É possível verificar o tempo de execução tanto da implementação em C++, quanto da implementação em CUDA.
A seguir, descrevemos as principais diferenças entre as abordagens:

| Aspecto | Implementação Serial (`mom.cpp`) | Implementação Paralela (`mom.cu`) |
|----------|----------------------------------|-----------------------------------|
| **Execução** | Realiza o cálculo da mediana de cada grupo de forma sequencial na CPU. | Cada thread da GPU calcula a mediana de um grupo simultaneamente. |
| **Desempenho** | Limitado pela capacidade de processamento de um único núcleo da CPU. | Escalável — aproveita centenas/milhares de núcleos da GPU em paralelo. |
| **Tempo de Execução (estimado)** | Cresce linearmente com o tamanho do vetor \( O(n) \). | Diminui consideravelmente para grandes vetores devido ao paralelismo massivo. |
| **Custo de Implementação** | Código simples e direto, sem dependências externas. | Exige controle de memória entre CPU ↔ GPU e configuração de *kernels*. |
| **Uso de Recursos** | Utiliza apenas o processador (CPU). | Utiliza a GPU e sua hierarquia de *threads* e *blocos*. |

### Objetivo da Comparação
A comparação permite demonstrar como a abordagem **Dividir e Conquistar** combinada com **execução paralela em CUDA** pode oferecer ganhos expressivos de tempo, especialmente em vetores grandes.
Mesmo em vetores pequenos, a diferença de desempenho é visível ao observar como o cálculo das medianas é distribuído entre diversas *threads*.

## Autores

Dupla responsável: **21**

- [Júlia Fortunato](https://github.com/julia-fortunato)
- [Maurício Ferreira](https://github.com/mauricio-araujoo)


## Vídeo de Apresentação

- [Vídeo de apresentação](https://youtu.be/8ifnQItyySs)
