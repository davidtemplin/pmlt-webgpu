class PathLogData {
    #config;

    buffer;

    constructor(params) {
        this.#config = params.config;
    }

    initialize(params) {
        const count = this.#config.path.length.max;
        const array = new ArrayBuffer(48 * count + 16);

        this.buffer = params.device.createBuffer({
            label: 'path_log buffer',
            size: array.byteLength,
            usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST | GPUBufferUsage.COPY_SRC,
        });
    
        params.device.queue.writeBuffer(this.buffer, 0, array);
    }

    getView(params) {
        const count = this.#config.path.length.max;
        
        const view = {
            vertices: [],
            beta: new Float32Array(params.array, 48 * count, 3),
            mis_weight: new Float32Array(params.array, 48 * count + 12, 1),
        };

        for (let i = 0; i < count; i++) {
            view.vertices.push({
                point: new Float32Array(params.array, 48 * i, 3),
                normal: new Float32Array(params.array, 48 * i + 16, 3),
                direction: new Float32Array(params.array, 48 * i + 32, 3),
                sphere_id: new Uint32Array(params.array, 48 * i + 44, 1),
            });
        }

        return view;
    }
}