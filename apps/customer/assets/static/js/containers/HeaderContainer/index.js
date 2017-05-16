import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import * as AuthenticationActionCreators from '../AuthenticationContainer/action';
import {
  Wrapper,
  FavoriteJobLink,
  BrandLink,
  HeaderLinkList,
  Button,
} from './styles';
import { A } from 'components';
import GoSignIn from 'react-icons/lib/go/sign-in';
import GoSignOut from 'react-icons/lib/go/sign-out';
import GoStar from 'react-icons/lib/go/star';


const propTypes = {
  actions: PropTypes.shape({
    logout: PropTypes.func.isRequired
  }).isRequired
};

const TITLE = 'STARTUP JOB';

const AUTH_GOOGLE_PATH = '/auth/google?scope=email';

function mapStateToProps({ authentication }) {
  const { authenticated, errorMessage } = authentication;
  return {
    authenticated,
    errorMessage,
  };
}
function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(
      AuthenticationActionCreators,
      dispatch,
    ),
  };
}
class HeaderContainer extends Component {
  constructor(props) {
    super(props);
    this.handleLogout = this.handleLogout.bind(this);
    this.handleLogin = this.handleLogin.bind(this);
  }

  authenticated() {
    return !!localStorage.getItem('token');
  }

  handleLogout() {
    this.props.actions.logout();
  }

  handleLogin() {
    window.location = AUTH_GOOGLE_PATH;
  }

  renderButton() {
    if (this.authenticated()) return <Button type="button" onClick={this.handleLogout}><GoSignOut /></Button>;
    return <Button type="button" onClick={this.handleLogin} ><GoSignIn /></Button>;
  }

  renderFavoriteJobLink() {
    if (!this.authenticated()) { return; }
    return <FavoriteJobLink to="/favorite-jobs"><GoStar /></FavoriteJobLink>;
  }

  render() {
    return (
      <Wrapper>
        <BrandLink to="/">{TITLE}</BrandLink>
        <HeaderLinkList>
          {this.renderFavoriteJobLink()}
          {this.renderButton()}
        </HeaderLinkList>
      </Wrapper>
    );
  }
}

HeaderContainer.peropTypes = propTypes;
export default connect(mapStateToProps, mapDispatchToProps)(HeaderContainer);
