class InitializeKernel {
    #config;
    #data;
    #pipeline;

    constructor(params) {
        this.#config = params.config;
        this.#data = params.data;
    }

    initialize(params) {
        const module = params.device.createShaderModule({
            label: 'initialize module',
            code: INITIALIZE_CODE,
        });

        this.#pipeline = params.device.createComputePipeline({
            label: 'initialize compute pipeline',
            layout: this.#data.pipelineLayout.uniform,
            compute: {
                module,
            }
        });
    }

    encode(params) {
        const array = new ArrayBuffer(4);
        const view = {
            path_length: new Uint32Array(array, 0, 1),
        };
        view.path_length.set([params.pathLength]);
    
        const buffer = params.device.createBuffer({
            label: 'uniforms buffer',
            size: array.byteLength,
            usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
        });
    
        params.device.queue.writeBuffer(buffer, 0, array);
    
        const bindGroup = params.device.createBindGroup({
            label: 'initialize uniforms bind group',
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
        params.pass.dispatchWorkgroups(Math.ceil(this.#config.path.count / this.#config.workgroup.size));
    }
}