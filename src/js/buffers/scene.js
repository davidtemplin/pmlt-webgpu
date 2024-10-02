class SceneData {
    #scene;

    buffer;

    constructor(params) {
        this.#scene = params.scene;
    }

    initialize(params) {
        const array = new ArrayBuffer(28 * this.#scene.spheres.length);

        const view = this.getView({ array });
    
        for (let i = 0; i < this.#scene.spheres.length; i++) {
            const sphere = this.#scene.spheres[i];
            view.radius.set([sphere.radius], i);
            view.center[0].set([sphere.center.x], i);
            view.center[1].set([sphere.center.y], i);
            view.center[2].set([sphere.center.z], i);
            view.color[0].set([sphere.color.r], i);
            view.color[1].set([sphere.color.g], i);
            view.color[2].set([sphere.color.b], i);
        }

        this.buffer = params.device.createBuffer({
            label: 'sphere buffer',
            size: array.byteLength,
            usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST | GPUBufferUsage.COPY_SRC,
        });
    
        params.device.queue.writeBuffer(this.buffer, 0, array);
    }

    getView(params) {
        return {
            radius: new Float32Array(params.array, 0, this.#scene.spheres.length),
            center: [
                new Float32Array(params.array, 4 * this.#scene.spheres.length, this.#scene.spheres.length),
                new Float32Array(params.array, 8 * this.#scene.spheres.length, this.#scene.spheres.length),
                new Float32Array(params.array, 12 * this.#scene.spheres.length, this.#scene.spheres.length),
            ],
            color: [
                new Float32Array(params.array, 16 * this.#scene.spheres.length, this.#scene.spheres.length),
                new Float32Array(params.array, 20 * this.#scene.spheres.length, this.#scene.spheres.length),
                new Float32Array(params.array, 24 * this.#scene.spheres.length, this.#scene.spheres.length),
            ],
        };
    }
}