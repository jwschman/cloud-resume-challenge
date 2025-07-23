// This was pulled from a guide, and I kinda liked it I guess so I left it in
// but it's definitely unnecessary

function handler(event) {
    var request = event.request;
    var hostHeader = request.headers.host.value;

    var domainRegex = /(?:.*\.)?([a-z0-9\-]+\.[a-z]+)$/i;
    var match = hostHeader.match(domainRegex);

    if (!match || !hostHeader.startsWith('www.')) {
        return request;
    }

    // Extract the root domain
    var rootDomain = match[1];

    // Construct and return the redirect response
    return {
        statusCode: 301,
        statusDescription: 'Moved Permanently',
        headers: {
            "location": { "value": "https://" + rootDomain + request.uri },
            "cache-control": { "value": "max-age=3600" }
        }
    };
}
