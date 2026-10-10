# Findings — Part 4 Debug Lab

## Defect 1 — Container user

**Symptom:** The container needed an explicit non-root runtime user.

**Cause:** The runtime image did not specify a dedicated non-root user.

**Fix:** Added a system user with UID 10001 and configured the runtime stage to run as that user.

**How I found it:** Reviewed the service Dockerfile and configured the runtime image with explicit user ownership and execution settings.

## Defect 2 — Worker cache storage

**Symptom:** The worker needed writable cache storage while using a read-only root filesystem.

**Cause:** The cache directory lacked a dedicated writable volume.

**Fix:** Added an `emptyDir` volume mounted at `/var/cache/app`.

**How I found it:** Reviewed the worker's filesystem requirements and security context.

## Defect 3 — Metrics resource limit

**Symptom:** The metrics workload's CPU limit was incompatible with the lab resource quota.

**Cause:** The configured CPU limit exceeded the available quota.

**Fix:** Reduced the CPU limit to `500m` and retained a memory limit of `128Mi`.

**How I found it:** Compared the workload resource configuration with the namespace quota.

## Defect 4 — Reporter permissions

**Symptom:** The reporter needed permission to list pods in its namespace.

**Cause:** The reporter required appropriate Kubernetes API permissions.

**Fix:** Added a ServiceAccount, Role, and RoleBinding granting pod `get` and `list` permissions.

**How I found it:** Checked reporter logs and used `kubectl auth can-i list pods` with the reporter ServiceAccount. The permission check returned `yes`.

## Defect 5 — Gateway backend routing

**Symptom:** The gateway's `/status` endpoint needed to reach the backend service.

**Cause:** The gateway needed the correct backend service URL and port.

**Fix:** Configured `BACKEND_URL` as `http://backend.debug-lab.svc:8080`.

**How I found it:** Forwarded the gateway service to localhost and requested `/status`. The response returned `backend: ok` and `self: ok`.

## Defect 6 — Reporter parsing issue (unresolved)

**Symptom:** Reporter logs repeatedly showed `parse pod list: unexpected end of JSON input`, and `/report` returned an unhealthy response.

**Cause:** The exact root cause was not confirmed. An authenticated Kubernetes API request returned HTTP 200, and the reporter's pod-list parsing error persisted.

**Fix:** The parsing issue remains unresolved. The next investigation would compare the full API response received by the reporter with the response it attempts to decode, inspect any response-size limits, and identify where the JSON body becomes incomplete.

**How I found it:** Inspected reporter logs, checked ServiceAccount permissions, tested the authenticated Kubernetes API, and requested `/report` through the reporter port-forward.

## Remaining verification

The gateway was verified successfully. The reporter parsing issue remains unresolved, so the complete lab verification cannot be claimed as passing. The final scenario verification should be run before submission.
