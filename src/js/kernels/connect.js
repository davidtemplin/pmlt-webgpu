class ConnectKernel {
    #config;
    #data;
    #pipeline;

    constructor(params) {
        this.#config = params.config;
        this.#data = params.data;
    }

    initialize(params) {
        const module = params.device.createShaderModule({
            label: 'connect module',
            code: CONNECT_CODE,
        });

        this.#pipeline = params.device.createComputePipeline({
            label: 'connect compute pipeline',
            layout: this.#data.pipelineLayout.primary,
            compute: {
                module,
            }
        });
    }

    encode(params) {
        params.pass.setPipeline(this.#pipeline);
        params.pass.setBindGroup(0, this.#data.bindGroup.primary);
        params.pass.dispatchWorkgroupsIndirect(this.#data.element.dispatchIndirectParameters.buffer, 16 * this.#config.queue.index.connect);
    }
}