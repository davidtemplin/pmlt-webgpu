class ChainData {
    #config;

    buffer;

    constructor(params) {
        this.#config = params.config;
    }

    initialize(params) {
        const count = this.#config.path.length.max - 1;
        const array = new ArrayBuffer(84 * count);
    
        const view = this.getView({ array });
    
        for (let i = 0; i < count; i++) {
            const key = KeyUtil.parse(KEYS[i]);
            view.key[0].set([key.hi], i);
            view.key[1].set([key.lo], i);
            view.iteration.set([0], i);
            const vertexCount = i + 2;
            const numbersPerStream = vertexCount * this.#config.random.counts.vertex;
            const numbersPerPath = 2 * numbersPerStream + 1;
            const numbersPerIteration = numbersPerPath * this.#config.path.count;
            view.numbers_per_iteration.set([numbersPerIteration], i);
            view.numbers_per_path.set([numbersPerPath], i);
            view.numbers_per_stream.set([numbersPerStream], i);
            view.large_step_index[0].set([0], i);
            view.large_step_index[1].set([0], i);
            view.min_path_index.set([0], i);
            view.path_count.set([this.#config.path.count], i);
            view.offset.set([0], i);
        }

        this.buffer = params.device.createBuffer({
            label: 'chain buffer',
            size: array.byteLength,
            usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST | GPUBufferUsage.COPY_SRC,
        });
    
        params.device.queue.writeBuffer(this.buffer, 0, array);
    }

    getView(params) {
        const count = this.#config.path.length.max - 1;
        return {
            key: [
                new Uint32Array(params.array, 0, count),
                new Uint32Array(params.array, 4 * count, count),
            ],
            iteration: new Uint32Array(params.array, 8 * count, count),
            numbers_per_iteration: new Uint32Array(params.array, 12 * count, count),
            numbers_per_path: new Uint32Array(params.array, 16 * count, count),
            numbers_per_stream: new Uint32Array(params.array, 20 * count, count),
            large_step_index: [
                new Uint32Array(params.array, 24 * count, count),
                new Uint32Array(params.array, 28 * count, count),
            ],
            small_step_count: new Uint32Array(params.array, 32 * count, count),
            b: new Float32Array(params.array, 36 * count, count),
            pdf: new Float32Array(params.array, 40 * count, count),
            min_small_step_index: new Uint32Array(params.array, 44 * count, count),
            max_small_step_index: new Uint32Array(params.array, 48 * count, count),
            contribution: [
                new Float32Array(params.array, 52 * count, count),
                new Float32Array(params.array, 56 * count, count),
                new Float32Array(params.array, 60 * count, count),
            ],
            scalar_contribution: new Float32Array(params.array, 64 * count, count),
            min_path_index: new Uint32Array(params.array, 68 * count, count),
            max_path_index: new Uint32Array(params.array, 72 * count, count),
            path_count: new Uint32Array(params.array, 76 * count, count),
            offset: new Uint32Array(params.array, 80 * count, count),
        };
    }
}