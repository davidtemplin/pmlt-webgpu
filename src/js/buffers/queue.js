class QueueData {
    #config;

    buffer;

    constructor(params) {
        this.#config = params.config;
    }

    initialize(params) {
        this.buffer = params.device.createBuffer({
            label: 'queue buffer',
            size: 44 * this.#config.path.count + 4 * this.#config.queue.count,
            usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST | GPUBufferUsage.COPY_SRC,
        });
    }

    getView(params) {
        return {
            index: [
              new Uint32Array(params.array, 0, this.#config.path.count),
              new Uint32Array(params.array, 4 * this.#config.path.count, this.#config.path.count),
              new Uint32Array(params.array, 8 * this.#config.path.count, this.#config.path.count),
              new Uint32Array(params.array, 12 * this.#config.path.count, this.#config.path.count),
              new Uint32Array(params.array, 16 * this.#config.path.count, this.#config.path.count),
              new Uint32Array(params.array, 20 * this.#config.path.count, this.#config.path.count),
              new Uint32Array(params.array, 24 * this.#config.path.count, this.#config.path.count),
              new Uint32Array(params.array, 28 * this.#config.path.count, this.#config.path.count),
              new Uint32Array(params.array, 32 * this.#config.path.count, this.#config.path.count),
              new Uint32Array(params.array, 36 * this.#config.path.count, this.#config.path.count),
              new Uint32Array(params.array, 40 * this.#config.path.count, this.#config.path.count),
            ],
            count: new Uint32Array(params.array, 44 * this.#config.path.count, this.#config.queue.count),
          };
    }
}