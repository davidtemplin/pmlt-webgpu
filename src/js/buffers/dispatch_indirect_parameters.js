class DispatchIndirectParametersData {
    #config;

    buffer;

    constructor(params) {
        this.#config = params.config;
    }

    initialize(params) {
        const array = new Uint32Array(Array(4 * this.#config.queue.count).fill(0));

        this.buffer = params.device.createBuffer({
            label: 'dispatch indirect parameters buffer',
            size: array.byteLength,
            usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST | GPUBufferUsage.INDIRECT | GPUBufferUsage.COPY_SRC,
        });

        params.device.queue.writeBuffer(this.buffer, 0, array);
    }

    getView(params) {
        return new Uint32Array(params.array, 0, 4 * this.#config.queue.count);
    }
}