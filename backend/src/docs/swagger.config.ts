import { Request, Response } from 'express';

export const swaggerSpec = {
  openapi: '3.0.0',
  info: {
    title: 'RecycleX API Documentation',
    version: '1.0.0',
    description: 'Enterprise REST API for RecycleX Waste Collection, Resource Recovery & EcoCoin Ecosystem',
    contact: {
      name: 'RecycleX Engineering Team',
      email: 'dev@recyclex.org',
    },
  },
  servers: [
    {
      url: '/api/v1',
      description: 'API v1 Base Endpoint',
    },
  ],
  components: {
    securitySchemes: {
      bearerAuth: {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
      },
    },
  },
  paths: {
    '/health': {
      get: {
        summary: 'API Health Check',
        responses: {
          '200': {
            description: 'API is running normally',
          },
        },
      },
    },
  },
};

export function serveSwaggerJson(_req: Request, res: Response): void {
  res.json(swaggerSpec);
}

