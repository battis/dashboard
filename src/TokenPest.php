<?php

namespace Battis\GitHubIssueTracker;

use Pest;
	
class TokenPest extends Pest {
	
	protected $headers;
	
	public function __construct($baseUrl, $apiToken) {
		parent::__construct($baseUrl);
		$this->setupToken($apiToken);
	}
	
	public function setupToken($token, $authorizationPrefix = 'token') {
		$this->addHeader('Authorization', "$authorizationPrefix $token");
	}
	
	public function addHeader($key, $value) {
		$this->headers[$key] = $value;
	}
	
	protected function prepHeaders($headers) {
		return parent::prepHeaders(array_merge($this->headers, $headers));
	}
}

?>