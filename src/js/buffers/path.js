class PathData {
    #config;

    buffer;

    constructor(params) {
        this.#config = params.config;
    }

    initialize(params) {
        const count = this.#config.path.count;
        this.buffer = params.device.createBuffer({
            label: 'path state buffer',
            size: 216 * count,
            usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST | GPUBufferUsage.COPY_SRC,
        });
    }

    getView(params) {
        const count = this.#config.path.count;
        return {
            step_type: new Uint32Array(params.array, 0, count),
            index: new Uint32Array(params.array, 4 * count, count),
            length: new Uint32Array(params.array, 8 * count, count),
            vertex_index: new Uint32Array(params.array, 12 * count, count),
            technique: [
                new Uint32Array(params.array, 16 * count, count),
                new Uint32Array(params.array, 20 * count, count),
            ],
            ray_origin: [
                new Float32Array(params.array, 24 * count, count),
                new Float32Array(params.array, 28 * count, count),
                new Float32Array(params.array, 32 * count, count),
            ],
            ray_direction: [
                new Float32Array(params.array, 36 * count, count),
                new Float32Array(params.array, 40 * count, count),
                new Float32Array(params.array, 44 * count, count),
            ],
            beta: [
                new Float32Array(params.array, 48 * count, count),
                new Float32Array(params.array, 52 * count, count),
                new Float32Array(params.array, 56 * count, count),
            ],
            pixel: [
                new Uint32Array(params.array, 60 * count, count),
                new Uint32Array(params.array, 64 * count, count),
            ],
            cdf: new Float32Array(params.array, 68 * count, count),
            point: [
                [
                    [
                        new Float32Array(params.array, 72 * count, count),
                        new Float32Array(params.array, 76 * count, count),
                        new Float32Array(params.array, 80 * count, count),
                    ],
                    [
                        new Float32Array(params.array, 84 * count, count),
                        new Float32Array(params.array, 88 * count, count),
                        new Float32Array(params.array, 92 * count, count),
                    ],
                ],
                [
                    [
                        new Float32Array(params.array, 96 * count, count),
                        new Float32Array(params.array, 100 * count, count),
                        new Float32Array(params.array, 104 * count, count),
                    ],
                    [
                        new Float32Array(params.array, 108 * count, count),
                        new Float32Array(params.array, 112 * count, count),
                        new Float32Array(params.array, 116 * count, count),
                    ],
                ],
            ],
            normal: [
                [
                    [
                        new Float32Array(params.array, 120 * count, count),
                        new Float32Array(params.array, 124 * count, count),
                        new Float32Array(params.array, 128 * count, count),
                    ],
                    [
                        new Float32Array(params.array, 132 * count, count),
                        new Float32Array(params.array, 136 * count, count),
                        new Float32Array(params.array, 140 * count, count),
                    ],
                ],
                [
                    [
                        new Float32Array(params.array, 144 * count, count),
                        new Float32Array(params.array, 148 * count, count),
                        new Float32Array(params.array, 152 * count, count),
                    ],
                    [
                        new Float32Array(params.array, 156 * count, count),
                        new Float32Array(params.array, 160 * count, count),
                        new Float32Array(params.array, 164 * count, count),
                    ],
                ],
            ],
            material_id: [
                new Uint32Array(params.array, 168 * count, count),
                new Uint32Array(params.array, 172 * count, count),
            ],
            pdf_fwd: [
                [
                    new Float32Array(params.array, 176 * count, count),
                    new Float32Array(params.array, 180 * count, count),
                ],
                [
                    new Float32Array(params.array, 184 * count, count),
                    new Float32Array(params.array, 188 * count, count),
                ],
            ],
            sum_inv_ri: [
                new Float32Array(params.array, 192 * count, count),
                new Float32Array(params.array, 196 * count, count),
            ],
            prod_ri: [
                new Float32Array(params.array, 200 * count, count),
                new Float32Array(params.array, 204 * count, count),
            ],
            directional_pdf: new Float32Array(params.array, 208 * count, count),
            final_ri: new Float32Array(params.array, 212 * count, count),
        };
    }
}