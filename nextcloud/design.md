# Nextcloud Weblet Design Decisions

This image uses the Nextcloud AIO (All-in-One) deployment method to bring up a Nextcloud installation in a micro VM on the ThreeFold Grid. It has been designed to work with the following combinations of the Grid's web gateway, dedicated public IPv4 addresses, and user supplied domains:

1. Public IPv4 + user domain
2. Public IPv4 + gateway domain
3. Gateway with user domain
4. Gateway with gateway domain

AIO gives the user the option to deploy their own STUN and TURN server for Nextcloud Talk video conferencing, and this is the only feature that requires the use of a public IPv4. Otherwise, all traffic can pass over the HTTP web gateway.

There is a complication in that AIO provides a separate web management interface, which is typically accessed on port 8080 or 8443. Since the web gateway only listens on port 443, we need to take another approach. Simply deploying two gateways is a possible solution. However, support for multiple gateways in a single deployment was not present in the Playground at the time this weblet was developed and each gateway does introduce a small additional cost.

Therefore, this image includes Caddy as a reverse proxy in order to serve the AIO interface under a "subfolder" of `/aio`. Serving Nextcloud via a reverse proxy is well supported by AIO and for that part following the reverse proxy instructions is all that's required. Relocating the AIO web interface to `/aio` requires rewriting some HTTP headers, as well as some parts of the HTML and CSS files that are returned. This is all done within the reverse proxy directives, in line with a guiding principle of avoiding depending on making any upsream source code changes.

Along with Talk, there is another component that causes some difficulty when using the web gateway, and that is Collabora, the online document editing and collaboration engine that's available with AIO. Specifically, Nextcloud implements an allowed list of IPs are that are able to make the WOPI requests used by Collabora to access and edit files stored in the Nextcloud instance. This is done to address a specific and very limited [security gap](github.com/nextcloud/security-advisories/security/advisories/GHSA-24x8-h6m2-9jf2) to ensure that watermark and download protection features work can't be bypassed. For the strongest implementation of these features, please reserve a public IPv4 address for the VM running Nextcloud.

AIO configures the allowed IP list to a reasonable default for typical deployments where Nextcloud and any reverse proxy are running on the same system. In our case, using the web gateway means that this might not be true. And since this WOPI traffic targets the domain of the instance, it always traverses the gateway even though it's traffic between two containers running in the same VM. Thus, we must allow traffic from the apparent public IP of the VM, which could be the public IPv4 address reserved if any, the public IP of the node if any, or the public IP of the router upstream from the node otherwise.

Within the configuration script included with this image, we add the apparent public IP of the VM to the allowed IP list for WOPI requests. That means that whenever a dedicated public IP is not reserved for the VM, other VMs running on the same node or other nodes in the same farm would have the same apparent public IP and would not be blocked by the allow list mechanism. This *does not* provide anyone a means to access documents in the Nextcloud instance that have not already been shared with them. It's only a route to download a non watermarked version of a shared document, when watermarking or download restriction were enabled.