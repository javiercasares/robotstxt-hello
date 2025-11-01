<?php
/**
 * Plugin Name:       ROBOTSTXT Hello
 * Plugin URI:        https://www.robotstxt.es/plugins/robotstxt-hello
 * Description:       Adds a Hello admin page for demonstration purposes.
 * Version:           1.0.2
 * Requires at least: 4.7
 * Requires PHP:      5.6
 * Author:            ROBOTSTXT
 * Author URI:        https://www.robotstxt.es/
 * License:           GPL-2.0-or-later
 * License URI:       https://spdx.org/licenses/GPL-2.0-or-later.html
 * Text Domain:       robotstxt-hello
 * Domain Path:       /languages
 *
 * @package ROBOTSTXT_Hello
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

require_once __DIR__ . '/includes/class-robotstxt-hello-plugin.php';

( new Robotstxt_Hello_Plugin() )->register();
