<?php
/**
 * Plugin Name:       Robots.txt Hello
 * Plugin URI:        https://example.com/plugins/robotstxt-hello
 * Description:       Adds a Hello admin page for demonstration purposes.
 * Version:           1.0.0
 * Requires at least: 6.3
 * Requires PHP:      8.2
 * Author:            Example Author
 * Author URI:        https://example.com
 * License:           GPLv2 or later
 * License URI:       https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain:       robotstxt-hello
 * Domain Path:       /languages
 *
 * @package Robotstxt_Hello
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

require_once __DIR__ . '/includes/class-robotstxt-hello-plugin.php';

( new Robotstxt_Hello_Plugin() )->register();
