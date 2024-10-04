class CameraData {
    #config;
    #scene;

    buffer;

    constructor(params) {
        this.#config = params.config;
        this.#scene = params.scene;
    }

    initialize(params) {
        const array = new ArrayBuffer(64);
        const view = this.getView({ array });
        const direction = VectorMath.sub(this.#scene.camera.lookAt, this.#scene.camera.origin);
        const distance = this.#config.image.height / (2.0 * Math.tan((this.#scene.camera.fieldOfView * Math.PI / 180.0) / 2.0));
        const basis = VectorMath.orthonormalBasis(direction);
        view.u.set([basis.u.x, basis.u.y, basis.u.z]);
        view.v.set([basis.v.x, basis.v.y, basis.v.z]);
        view.w.set([basis.w.x, basis.w.y, basis.w.z]);
        view.origin.set([this.#scene.camera.origin.x, this.#scene.camera.origin.y, this.#scene.camera.origin.z]);
        view.distance.set([distance]);
        this.buffer = params.device.createBuffer({
            label: 'camera buffer',
            size: array.byteLength,
            usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST | GPUBufferUsage.COPY_SRC,
        });
        params.device.queue.writeBuffer(this.buffer, 0, array);
    }

    getView(params) {
        return {
            u: new Float32Array(params.array, 0, 3),
            v: new Float32Array(params.array, 16, 3),
            w: new Float32Array(params.array, 32, 3),
            origin: new Float32Array(params.array, 48, 3),
            distance: new Float32Array(params.array, 60, 1),
        };
    }
}