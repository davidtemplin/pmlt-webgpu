class EnableImageKernel {
    #config;
    #data;
    #pipeline;

    constructor(params) {
        this.#config = params.config;
        this.#data = params.data;
    }

    initialize(params) {
        const module = params.device.createShaderModule({
            label: 'enable_image module',
            code: ENABLE_IMAGE_CODE,
        });

        this.#pipeline = params.device.createComputePipeline({
            label: 'enable_image compute pipeline',
            layout: this.#data.pipelineLayout.auxiliary,
            compute: {
                module,
            }
        });
    }

    encode(params) {
        params.pass.setPipeline(this.#pipeline);
        params.pass.setBindGroup(this.#config.bindGroup.primary.index, this.#data.bindGroup.primary);
        params.pass.setBindGroup(this.#config.bindGroup.auxiliary.index, this.#data.bindGroup.auxiliary);
        params.pass.dispatchWorkgroups(1);
    }
}