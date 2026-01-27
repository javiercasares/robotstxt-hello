<?php
/**
 * JSON-based updater for robotstxt-hello plugin.
 *
 * @package ROBOTSTXT_Hello
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

/**
 * Class Robotstxt_Hello_Updater
 *
 * Handles plugin updates from a remote JSON endpoint.
 */
class Robotstxt_Hello_Updater {

	/**
	 * Plugin file basename (e.g., 'robotstxt-hello/robotstxt-hello.php').
	 *
	 * @var string
	 */
	private string $plugin_file;

	/**
	 * Remote JSON endpoint URL.
	 *
	 * @var string
	 */
	private string $json_url;

	/**
	 * Cache key for storing remote data.
	 *
	 * @var string
	 */
	private string $cache_key;

	/**
	 * Constructor.
	 *
	 * @param string $plugin_file Plugin basename.
	 * @param string $json_url    Remote JSON URL.
	 */
	public function __construct( string $plugin_file, string $json_url ) {
		$this->plugin_file = $plugin_file;
		$this->json_url    = $json_url;
		$this->cache_key   = 'robotstxt_hello_update_' . md5( $plugin_file . '|' . $json_url );
	}

	/**
	 * Register hooks for the updater.
	 */
	public function register(): void {
		add_filter( 'pre_set_site_transient_update_plugins', array( $this, 'inject_update_info' ) );
		add_filter( 'plugins_api', array( $this, 'provide_plugin_details' ), 10, 3 );
	}

	/**
	 * Inject update info into WP's plugin update transient.
	 *
	 * @param object|mixed $transient The update_plugins transient.
	 *
	 * @return object The modified transient.
	 */
	public function inject_update_info( $transient ) {
		if ( ! is_object( $transient ) ) {
			$transient = new stdClass();
		}

		if ( empty( $transient->checked ) || ! is_array( $transient->checked ) ) {
			return $transient;
		}

		// WP only checks plugins it knows about.
		if ( empty( $transient->checked[ $this->plugin_file ] ) ) {
			return $transient;
		}

		$current_version = $transient->checked[ $this->plugin_file ];

		// Fetch remote data (cached).
		$remote = $this->get_remote_data();

		if ( empty( $remote['version'] ) || empty( $remote['download_url'] ) ) {
			return $transient;
		}

		// Check compatibility gates.
		if ( ! $this->is_compatible( $remote ) ) {
			return $transient;
		}

		// Compare versions.
		if ( version_compare( $remote['version'], $current_version, '>' ) ) {
			$update = (object) array(
				'slug'         => $remote['slug'] ?? dirname( $this->plugin_file ),
				'plugin'       => $this->plugin_file,
				'new_version'  => $remote['version'],
				'url'          => $remote['homepage'] ?? '',
				'package'      => $remote['download_url'],
				'tested'       => $remote['tested'] ?? '',
				'requires'     => $remote['requires'] ?? '',
				'requires_php' => $remote['requires_php'] ?? '',
			);

			$transient->response[ $this->plugin_file ] = $update;
		}

		return $transient;
	}

	/**
	 * Provide "View details" modal content from the JSON.
	 *
	 * @param false|object|array $result The result object or array.
	 * @param string             $action The type of information being requested.
	 * @param object             $args   Plugin API arguments.
	 *
	 * @return false|object The plugin information object or false.
	 */
	public function provide_plugin_details( $result, string $action, object $args ) {
		if ( 'plugin_information' !== $action ) {
			return $result;
		}

		$slug = dirname( $this->plugin_file );
		if ( empty( $args->slug ) || $args->slug !== $slug ) {
			return $result;
		}

		$remote = $this->get_remote_data();

		if ( empty( $remote['version'] ) ) {
			return $result;
		}

		return (object) array(
			'name'          => $remote['name'] ?? $slug,
			'slug'          => $remote['slug'] ?? $slug,
			'version'       => $remote['version'],
			'author'        => $remote['author'] ?? '',
			'homepage'      => $remote['homepage'] ?? '',
			'requires'      => $remote['requires'] ?? '',
			'tested'        => $remote['tested'] ?? '',
			'requires_php'  => $remote['requires_php'] ?? '',
			'sections'      => array(
				'description' => $remote['description'] ?? '',
				'changelog'   => $remote['changelog'] ?? '',
			),
			'download_link' => $remote['download_url'] ?? '',
		);
	}

	/**
	 * Fetch remote update data (with caching).
	 *
	 * @return array Remote data or empty array on failure.
	 */
	private function get_remote_data(): array {
		$remote = get_site_transient( $this->cache_key );

		if ( false === $remote ) {
			$remote = $this->fetch_json();
			// Cache for 6 hours.
			set_site_transient( $this->cache_key, $remote ?: array(), 6 * HOUR_IN_SECONDS );
		}

		return is_array( $remote ) ? $remote : array();
	}

	/**
	 * Fetch JSON from remote URL.
	 *
	 * @return array Decoded JSON data or empty array on failure.
	 */
	private function fetch_json(): array {
		$response = wp_remote_get(
			$this->json_url,
			array(
				'timeout' => 10,
				'headers' => array(
					'Accept' => 'application/json',
				),
			)
		);

		if ( is_wp_error( $response ) ) {
			return array();
		}

		$code = (int) wp_remote_retrieve_response_code( $response );
		if ( $code < 200 || $code >= 300 ) {
			return array();
		}

		$body = wp_remote_retrieve_body( $response );
		$data = json_decode( $body, true );

		return is_array( $data ) ? $data : array();
	}

	/**
	 * Check if the remote version is compatible with current environment.
	 *
	 * @param array $remote Remote plugin data.
	 *
	 * @return bool True if compatible, false otherwise.
	 */
	private function is_compatible( array $remote ): bool {
		// Check PHP version.
		if ( ! empty( $remote['requires_php'] ) ) {
			if ( version_compare( PHP_VERSION, $remote['requires_php'], '<' ) ) {
				return false;
			}
		}

		// Check WordPress version.
		if ( ! empty( $remote['requires'] ) ) {
			if ( version_compare( get_bloginfo( 'version' ), $remote['requires'], '<' ) ) {
				return false;
			}
		}

		return true;
	}

	/**
	 * Clear the update cache manually.
	 *
	 * Useful for testing or after publishing a new version.
	 */
	public function clear_cache(): void {
		delete_site_transient( $this->cache_key );
	}
}
