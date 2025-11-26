<?php
/**
 * Plugin Name:       Hello (by ROBOTSTXT)
 * Plugin URI:        https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello
 * Description:       Adds a Hello admin page for demonstration purposes.
 * Version:           1.1.0
 * Requires at least: 4.7
 * Requires PHP:      5.6
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

( new Robotstxt_Hello_Plugin() )->register();
