#include <iostream>
#include <vector>
#include <algorithm>
#include <cuda_runtime.h>
#include <cmath>
#include <chrono>
#include <random>

#define CHUNK_SIZE 5

// Kernel: calcula a mediana de cada grupo de 5 elementos
__global__ void calcular_chunk_medianas(const int* data, int* medianas, int n) {
    int chunkId = blockIdx.x * blockDim.x + threadIdx.x;
    int inicio = chunkId * CHUNK_SIZE;
    int fim = fmin(inicio + CHUNK_SIZE, n);

    if (inicio >= n) return;

    int local[CHUNK_SIZE];
    int contador = 0;
    for (int i = inicio; i < fim; ++i) {
        local[contador++] = data[i];
    }

    for (int i = 0; i < contador - 1; ++i) {
        for (int j = 0; j < contador - i - 1; ++j) {
            if (local[j] > local[j + 1]) {
                int tmp = local[j];
                local[j] = local[j + 1];
                local[j + 1] = tmp;
            }
        }
    }

    int medianIdx = contador / 2;
    medianas[chunkId] = local[medianIdx];
}

int MoM(std::vector<int>& data) {
    int n = data.size();
    if (n <= CHUNK_SIZE) {
        std::sort(data.begin(), data.end());
        return data[n / 2];
    }

    int* d_data;
    int numChunks = (n + CHUNK_SIZE - 1) / CHUNK_SIZE;
    int* d_medianas;

    cudaMalloc(&d_data, n * sizeof(int));
    cudaMalloc(&d_medianas, numChunks * sizeof(int));

    cudaMemcpy(d_data, data.data(), n * sizeof(int), cudaMemcpyHostToDevice);

    int threads = 256;
    int blocks = (numChunks + threads - 1) / threads;
    calcular_chunk_medianas<<<blocks, threads>>>(d_data, d_medianas, n);
    cudaDeviceSynchronize();

    std::vector<int> medianas(numChunks);
    cudaMemcpy(medianas.data(), d_medianas, numChunks * sizeof(int), cudaMemcpyDeviceToHost);

    cudaFree(d_data);
    cudaFree(d_medianas);

    return MoM(medianas);
}

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
