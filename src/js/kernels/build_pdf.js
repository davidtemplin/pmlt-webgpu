class BuildPdfKernel {
    #config;
    #data;
    #pipeline;

    constructor(params) {
        this.#config = params.config;
        this.#data = params.data;
    }

    initialize(params) {
        const module = params.device.createShaderModule({
            label: 'build_pdf module',
            code: BUILD_PDF_CODE,
        });

        this.#pipeline = params.device.createComputePipeline({
            label: 'build_pdf compute pipeline',
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