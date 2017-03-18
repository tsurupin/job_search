import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Link } from 'react-router';
import * as AuthenticationActionCreators from '../AuthenticationContainer/action';
import styles from './styles.css';

const propTypes = {

}

const AUTH_GOOGLE_PATH = '/auth/google?scope=email';

function mapStateToProps({authentication}) {
  const { authenticated, errorMessage } = authentication;
  return {
    authenticated,
    errorMessage
  }
};

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(
      AuthenticationActionCreators,
      dispatch
    )
  }
};


class HeaderContainer extends Component {
  constructor(props) {
    super(props);
    this.handleLogout = this.handleLogout.bind(this);
  }

  authenticated() {
    return !!localStorage.getItem("token");
  }

  handleLogout() {
    this.props.actions.logout();
  }

  renderButton() {
    if (this.authenticated()) return <button type='submit' onClick={this.handleLogout}>Logout</button>
    return <a href={AUTH_GOOGLE_PATH}>LogIn</a>
  }

  renderFavoriteJobLink() {
    if (!this.authenticated()){ return }
    return <Link to="/favorite-jobs">Favorite Job</Link>;
  }

  render() {
    return (
      <header>
        <Link to="/"> Jobs</Link>
        {this.renderFavoriteJobLink()}
        {this.renderButton()}
      </header>
    )
  }
}

HeaderContainer.peropTypes = propTypes;
export default connect(mapStateToProps, mapDispatchToProps)(HeaderContainer);
