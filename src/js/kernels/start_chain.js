class StartChainKernel {
    #config;
    #data;
    #pipeline;

    constructor(params) {
        this.#config = params.config;
        this.#data = params.data;
    }

    initialize(params) {
        const module = params.device.createShaderModule({
            label: 'start_chain module',
            code: START_CHAIN_CODE,
        });

        this.#pipeline = params.device.createComputePipeline({
            label: 'start_chain compute pipeline',
            layout: this.#data.pipelineLayout.uniform,
            compute: {
                module,
            }
        });
    }

    encode(params) {
        const array = new ArrayBuffer(8);
        const view = {
            chain_id: new Uint32Array(array, 0, 1),
            random: new Float32Array(array, 4, 1),
        };
        view.chain_id.set([params.chainId]);
        view.random.set([params.random]);
    
        const buffer = params.device.createBuffer({
            label: 'start_chain uniforms buffer',
            size: array.byteLength,
            usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
        });
    
        params.device.queue.writeBuffer(buffer, 0, array);
    
        const bindGroup = params.device.createBindGroup({
            label: 'start_chain uniforms bind group',
            layout: this.#data.bindGroupLayout.uniform,
            entries: [
                {
                    binding: this.#config.bindGroup.uniform.binding.parameters,
                    resource: {
                        buffer,
                    },
                },
            ],
        });

        params.pass.setPipeline(this.#pipeline);
        params.pass.setBindGroup(this.#config.bindGroup.primary.index, this.#data.bindGroup.primary);
        params.pass.setBindGroup(this.#config.bindGroup.auxiliary.index, this.#data.bindGroup.auxiliary);
        params.pass.setBindGroup(this.#config.bindGroup.uniform.index, bindGroup);
        params.pass.dispatchWorkgroups(1);
    }
}