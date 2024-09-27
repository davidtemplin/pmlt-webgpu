class ImageData {
    #config;

    buffer;

    constructor(params) {
        this.#config = params.config;
    }

    initialize(params) {
        const count = this.#config.image.width * this.#config.image.height;
        this.buffer = params.device.createBuffer({
            label: 'image buffer',
            size: 12 * count,
            usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST,
        });
    }

    getView(params) {
        const count = this.#config.image.width * this.#config.image.height;
        return {
            pixels: [
                [
                    new Uint32Array(params.array, 0, count),
                ],
                [
                    new Uint32Array(params.array, 4 * count, count),
                ],
                [
                    new Uint32Array(params.array, 8 * count, count),
                ],
            ],
        };
    }
}