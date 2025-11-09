#include <iostream>
#include <vector>
#include <algorithm>
#include <cmath>
#include <chrono>
#include <random>

#define CHUNK_SIZE 5

// calcula a mediana de cada grupo de 5 elementos de forma sequencial
void calcular_chunk_medianas(const std::vector<int>& data, std::vector<int>& medianas, int n) {
    int numChunks = (n + CHUNK_SIZE - 1) / CHUNK_SIZE;
    medianas.resize(numChunks);

    for (int chunkId = 0; chunkId < numChunks; ++chunkId) {
        int inicio = chunkId * CHUNK_SIZE;
        int fim = std::min(inicio + CHUNK_SIZE, n);

        std::vector<int> local;
        for (int i = inicio; i < fim; ++i)
            local.push_back(data[i]);

        for (int i = 0; i < (int)local.size() - 1; ++i) {
            for (int j = 0; j < (int)local.size() - i - 1; ++j) {
                if (local[j] > local[j + 1]) {
                    int tmp = local[j];
                    local[j] = local[j + 1];
                    local[j + 1] = tmp;
                }
            }
        }

        int medianIdx = local.size() / 2;
        medianas[chunkId] = local[medianIdx];
    }
}

// mediana das medianas recursiva
int MoM(std::vector<int>& data) {
    int n = data.size();
    if (n <= CHUNK_SIZE) {
        std::sort(data.begin(), data.end());
        return data[n / 2];
    }

    std::vector<int> medianas;
    calcular_chunk_medianas(data, medianas, n);

    return MoM(medianas);
}

// seleção
int mediana(std::vector<int> data, int k) {
    if (data.size() == 1)
        return data[0];

    int mom = MoM(data);

    std::vector<int> esq, dir, igual;
    for (int v : data) {
        if (v < mom) esq.push_back(v);
        else if (v > mom) dir.push_back(v);
        else igual.push_back(v);
    }

    int L = esq.size();
    int E = igual.size();

    if (k <= L)
        return mediana(esq, k);
    else if (k <= L + E)
        return mom;
    else
        return mediana(dir, k - L - E);
}

// Função principal
int main() {
    std::vector<int> data(50000);
    std::mt19937 gen(42);
    std::uniform_int_distribution<int> dist(0, 100000);

    int k = static_cast<int>(std::ceil(data.size() / 2.0));

    auto inicio = std::chrono::high_resolution_clock::now();

    int mom = mediana(data, k);

    auto fim = std::chrono::high_resolution_clock::now();

    // tempo de execução da chamada de função
    std::chrono::duration<double, std::milli> duracao = fim - inicio;

    std::cout << "Tempo de execucao: " << duracao.count() << " ms\n";

    std::cout << "Mediana das medianas: " << mom << "\n";
    return 0;
}
