class BuildCdfKernel {
    #config;
    #data;
    #pipeline;

    constructor(params) {
        this.#config = params.config;
        this.#data = params.data;
    }

    initialize(params) {
        const module = params.device.createShaderModule({
            label: 'build_cdf module',
            code: BUILD_CDF_CODE,
        });

        this.#pipeline = params.device.createComputePipeline({
            label: 'build_cdf compute pipeline',
            layout: this.#data.pipelineLayout.uniform,
            compute: {
                module,
            }
        });
    }

    encode(params) {
        const iterations = Math.ceil(Math.log2(this.#config.path.count));
        for (var iteration = 0; iteration < iterations; iteration++) {
            const array = new ArrayBuffer(8);
            const view = {
                chain_id: new Uint32Array(array, 0, 1),
                iteration: new Uint32Array(array, 4, 1),
            };
            view.chain_id.set([params.chainId]);
            view.iteration.set([iteration]);
        
            const buffer = params.device.createBuffer({
                label: 'build_cdf uniforms buffer',
                size: array.byteLength,
                usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
            });
        
            params.device.queue.writeBuffer(buffer, 0, array);
        
            const bindGroup = params.device.createBindGroup({
                label: 'build_cdf uniforms bind group',
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
}