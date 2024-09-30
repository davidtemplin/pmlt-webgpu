class PostConnectLightIndirectKernel {
    #config;
    #data;
    #pipeline;

    constructor(params) {
        this.#config = params.config;
        this.#data = params.data;
    }

    initialize(params) {
        const module = params.device.createShaderModule({
            label: 'post-connect light indirect module',
            code: POST_CONNECT_LIGHT_INDIRECT_CODE,
        });

        this.#pipeline = params.device.createComputePipeline({
            label: 'post-connect light indirect compute pipeline',
            layout: this.#data.pipelineLayout.primary,
            compute: {
                module,
            }
        });
    }

    encode(params) {
        params.pass.setPipeline(this.#pipeline);
        params.pass.setBindGroup(this.#config.bindGroup.primary.index, this.#data.bindGroup.primary);
        params.pass.dispatchWorkgroupsIndirect(this.#data.element.dispatchIndirectParameters.buffer, 16 * this.#config.queue.index.postConnect.light.indirect);
    }
}