class Timestamp {
    #resolveBuffer;
    #resultBuffer;

    constructor() {

    }

    prepare(params) {
        this.#resolveBuffer = device.createBuffer({
            size: params.querySet.count * 8,
            usage: GPUBufferUsage.QUERY_RESOLVE | GPUBufferUsage.COPY_SRC,
        });

        this.#resultBuffer = device.createBuffer({
            size: resolveBuffer.size,
            usage: GPUBufferUsage.COPY_DST | GPUBufferUsage.MAP_READ,
        });

        params.encoder.resolveQuerySet(params.querySet, 0, 2, this.#resolveBuffer, 0);

        if (this.#resultBuffer.mapState === 'unmapped') {
        params.encoder.copyBufferToBuffer(this.#resolveBuffer, 0, this.#resultBuffer, 0, this.#resultBuffer.size);
        }
    }

    async log() {
        if (this.#resultBuffer.mapState === 'unmapped') {
            await this.#resultBuffer.mapAsync(GPUMapMode.READ).then(() => {
                const times = new BigInt64Array(this.#resultBuffer.getMappedRange());
                const gpuTime = Number(times[1] - times[0]) /  1_000_000.0;
                console.log(`elapsed time: ${gpuTime} ms.`);
                this.#resultBuffer.unmap();
            });
        }
    }
}