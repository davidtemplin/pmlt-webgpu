class RenderKernel {
    #config;
    #data;
    #pipeline;

    constructor(params) {
        this.#config = params.config;
        this.#data = params.data;
    }

    initialize(params) {
        const vertexModule = params.device.createShaderModule({
            label: 'vertex shader module',
            code: VERTEX_CODE,
        });

        const fragmentModule = params.device.createShaderModule({
            label: 'fragment shader module',
            code: FRAGMENT_CODE,
        });

        this.#pipeline = params.device.createRenderPipeline({
            label: 'render pipeline',
            layout: this.#data.pipelineLayout.primary,
            vertex: {
                module: vertexModule,
            },
            fragment: {
                module: fragmentModule,
                targets: [
                    {
                        format: params.presentationFormat,
                    },
                ],
            },
        });
    }

    encode(params) {
        params.pass.setPipeline(this.#pipeline);
        params.pass.setBindGroup(this.#config.bindGroup.primary.index, this.#data.bindGroup.primary);
        pass.draw(6);
    }
}