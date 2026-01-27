<?php
/**
 * Plugin Name:       Hello (by ROBOTSTXT)
 * Plugin URI:        https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello
 * Description:       Adds a Hello admin page for demonstration purposes.
 * Version:           1.1.2
 * Requires at least: 6.5
 * Requires PHP:      8.2
 * Network:           true
 * Security:          robotstxt@robotstxt.es
 * Author:            ROBOTSTXT
 * Author URI:        https://www.robotstxt.es/
 * Text Domain:       robotstxt-hello
 * Domain Path:       /languages
 * License:           GPL-3.0-or-later
 * License URI:       https://www.gnu.org/licenses/gpl-3.0.html
 * Gitea Plugin URI:  ROBOTSTXT/robotstxt-hello
 * Gitea Plugin URI:  https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello
 * Plugin ID:         did:plc:7umwjtio3qenfqiai2m5gsgg
 *
 * @package ROBOTSTXT_Hello
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

require_once __DIR__ . '/includes/class-robotstxt-hello-plugin.php';
require_once __DIR__ . '/includes/class-robotstxt-hello-updater.php';

( new Robotstxt_Hello_Plugin() )->register();

// Initialize the JSON updater.
$robotstxt_hello_updater = new Robotstxt_Hello_Updater(
	plugin_basename( __FILE__ ), // 'robotstxt-hello/robotstxt-hello.php'
	'https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/raw/branch/main/update.json'
);
$robotstxt_hello_updater->register();

/**
 * Clear updater cache (for testing/development).
 *
 * Usage: Add ?robotstxt_hello_clear_update_cache=1 to any admin page URL
 * or call do_action('robotstxt_hello_clear_update_cache') from code.
 */
add_action(
	'admin_init',
	function () use ( $robotstxt_hello_updater ) {
		if ( isset( $_GET['robotstxt_hello_clear_update_cache'] ) && current_user_can( 'update_plugins' ) ) {
			$robotstxt_hello_updater->clear_cache();
			delete_site_transient( 'update_plugins' );
			wp_safe_redirect( remove_query_arg( 'robotstxt_hello_clear_update_cache' ) );
			exit;
		}
	}
);

add_action(
	'robotstxt_hello_clear_update_cache',
	function () use ( $robotstxt_hello_updater ) {
		$robotstxt_hello_updater->clear_cache();
		delete_site_transient( 'update_plugins' );
	}
);
