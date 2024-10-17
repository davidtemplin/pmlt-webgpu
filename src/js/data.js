class Data {
    #config;
    #scene;

    bindGroup = {
        primary: {},
        auxiliary: {},
        uniform: {},
    };

    element = {};

    bindGroupLayout = {};

    pipelineLayout = {};

    constructor(params) {
        this.#config = params.config;
        this.#scene = params.scene;
    }

    initialize(params) {
        // Bind group layouts
        this.bindGroupLayout.primary = params.device.createBindGroupLayout({
            label: 'primary bind group layout',
            entries: [
                {
                    binding: this.#config.bindGroup.primary.binding.camera,
                    visibility: GPUShaderStage.COMPUTE,
                    buffer: {
                        type: 'read-only-storage',
                    },
                },
                {
                    binding: this.#config.bindGroup.primary.binding.sphere,
                    visibility: GPUShaderStage.COMPUTE,
                    buffer: {
                        type: 'read-only-storage',
                    },
                },
                {
                    binding: this.#config.bindGroup.primary.binding.chain,
                    visibility: GPUShaderStage.COMPUTE,
                    buffer: {
                        type: 'storage',
                    },
                },
                {
                    binding: this.#config.bindGroup.primary.binding.path,
                    visibility: GPUShaderStage.COMPUTE,
                    buffer: {
                        type: 'storage',
                    },
                },
                {
                    binding: this.#config.bindGroup.primary.binding.image,
                    visibility: GPUShaderStage.COMPUTE | GPUShaderStage.FRAGMENT,
                    buffer: {
                        type: 'storage',
                    },
                },
                {
                    binding: this.#config.bindGroup.primary.binding.queue,
                    visibility: GPUShaderStage.COMPUTE,
                    buffer: {
                        type: 'storage',
                    },
                },
                {
                    binding: this.#config.bindGroup.primary.binding.pathLog,
                    visibility: GPUShaderStage.COMPUTE,
                    buffer: {
                        type: 'storage',
                    },
                },
            ],
        });

        this.bindGroupLayout.auxiliary = params.device.createBindGroupLayout({
            label: 'auxiliary bind group layout',
            entries: [
                {
                    binding: this.#config.bindGroup.auxiliary.binding.dispatchIndirectParameters,
                    visibility: GPUShaderStage.COMPUTE,
                    buffer: {
                        type: 'storage',
                    },
                },
            ],
        });

        this.bindGroupLayout.uniform = params.device.createBindGroupLayout({
            label: 'uniform bind group layout',
            entries: [
                {
                    binding: this.#config.bindGroup.uniform.binding.parameters,
                    visibility: GPUShaderStage.COMPUTE,
                    buffer: {
                        type: 'uniform',
                    },
                },
            ],
        });

        // Pipeline layouts
        this.pipelineLayout.primary = params.device.createPipelineLayout({
            bindGroupLayouts: [
                this.bindGroupLayout.primary,
            ],
        });
    
        this.pipelineLayout.auxiliary = params.device.createPipelineLayout({
            bindGroupLayouts: [
                this.bindGroupLayout.primary,
                this.bindGroupLayout.auxiliary,
            ],
        });
    
        this.pipelineLayout.uniform = params.device.createPipelineLayout({
            bindGroupLayouts: [
                this.bindGroupLayout.primary,
                this.bindGroupLayout.auxiliary,
                this.bindGroupLayout.uniform,
            ],
        });

        // Buffers
        this.element.camera = new CameraData({ config: this.#config, scene: this.#scene });
        this.element.camera.initialize({ device: params.device });
        this.element.sphere = new SceneData({ scene: this.#scene });
        this.element.sphere.initialize({ device: params.device });
        this.element.chain = new ChainData({ config: this.#config });
        this.element.chain.initialize({ device: params.device });
        this.element.path = new PathData({ config: this.#config });
        this.element.path.initialize({ device: params.device });
        this.element.image = new ImageData({ config: this.#config });
        this.element.image.initialize({ device: params.device });
        this.element.queue = new QueueData({ config: this.#config });
        this.element.queue.initialize({ device: params.device });
        this.element.pathLog = new PathLogData({ config: this.#config });
        this.element.pathLog.initialize({ device: params.device });
        this.element.dispatchIndirectParameters = new DispatchIndirectParametersData({ config: this.#config });
        this.element.dispatchIndirectParameters.initialize({ device: params.device });

        // Bind groups
        this.bindGroup.primary = params.device.createBindGroup({
            label: 'primary bind group',
            layout: this.bindGroupLayout.primary,
            entries: [
                {
                    binding: this.#config.bindGroup.primary.binding.camera,
                    resource: {
                        buffer: this.element.camera.buffer,
                    },
                },
                {
                    binding: this.#config.bindGroup.primary.binding.sphere,
                    resource: {
                        buffer: this.element.sphere.buffer,
                    },
                },
                {
                    binding: this.#config.bindGroup.primary.binding.chain,
                    resource: {
                        buffer: this.element.chain.buffer,
                    },
                },
                {
                    binding: this.#config.bindGroup.primary.binding.path,
                    resource: {
                        buffer: this.element.path.buffer,
                    },
                },
                {
                    binding: this.#config.bindGroup.primary.binding.image,
                    resource: {
                        buffer: this.element.image.buffer,
                    },
                },
                {
                    binding: this.#config.bindGroup.primary.binding.queue,
                    resource: {
                        buffer: this.element.queue.buffer,
                    },
                },
                {
                    binding: this.#config.bindGroup.primary.binding.pathLog,
                    resource: {
                        buffer: this.element.pathLog.buffer,
                    },
                },
            ],
        });
    
        this.bindGroup.auxiliary = params.device.createBindGroup({
            label: 'auxiliary bind group',
            layout: this.bindGroupLayout.auxiliary,
            entries: [
                {
                    binding: this.#config.bindGroup.auxiliary.binding.dispatchIndirectParameters,
                    resource: {
                        buffer: this.element.dispatchIndirectParameters.buffer,
                    },
                },
            ],
        });
    }
}