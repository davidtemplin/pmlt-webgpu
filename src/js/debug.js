class Debug {
    #label;
    #data;
    #resultBuffer;

    constructor(params) {
        this.#label = params.label;
        this.#data = params.data;
    }

    encode(params) {
        this.#resultBuffer = params.device.createBuffer({
            label: this.#label,
            size: this.#data.buffer.size,
            usage: GPUBufferUsage.MAP_READ | GPUBufferUsage.COPY_DST,
        });
    
        params.encoder.copyBufferToBuffer(this.#data.buffer, 0, this.#resultBuffer, 0, this.#resultBuffer.size);
    }

    async log() {
        await this.#resultBuffer.mapAsync(GPUMapMode.READ);
        const result = this.#resultBuffer.getMappedRange().slice();
        const view = this.#data.getView({ array: result });
        this.#resultBuffer.unmap();
        console.log(`${this.#label}:`);
        for (let key in view) {
            console.log(`${key}:`);
            console.log(view[key]);
        }
    }
}