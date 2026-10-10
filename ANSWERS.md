# Gateway API Migration Plan

1. Review existing Ingress hosts, paths, TLS settings, and annotations.
2. Install a Gateway API implementation and its CRDs in a test cluster.
3. Create GatewayClass, Gateway, and HTTPRoute resources for the existing routes and backend Services.
4. Configure listeners, TLS, route permissions, and cross-namespace references if needed.
5. Test routing, health checks, access controls, timeouts, and failure behavior in staging.
6. Compare traffic and logs with the existing Ingress, then migrate gradually with a rollback plan.
7. Update monitoring, documentation, and runbooks before removing the old Ingress.

Gateway API separates infrastructure ownership from application routing and offers a more extensible model. Supported features depend on the chosen controller.
