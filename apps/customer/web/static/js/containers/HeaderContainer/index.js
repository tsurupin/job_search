import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as HeaderActionCreators from './action';
import styles from './styles.css';

const propTypes = {

}


function mapStateToProps(response) {
  const { submitting, errorMessage } = response;
  return {
    submitting,
    errorMessage
  }
};

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(
      HeaderActionCreators,
      dispatch
    )
  }
};


class HeaderContainer extends Component {
  constructor(props) {
    super(props);

    this.state = {
      canSubmit: false
    }

    this.handleLogin = this.handleLogin.bind(this);
    this.handleLogout = this.handleLogout.bind(this);
  }

  // componentWillMount() {
  //   this.props.actions.fetch_url();
  // }

  handleLogin(event) {
    event.preventDefault();
    this.props.actions.login();
  }

  handleLogout(event) {
    event.preventDefault();
    this.props.actions.logout();
  }

  renderButton() {
    if (localStorage.getItem('accesssToken')) {
      return <button type='submit' onClick={this.handleLogout}>Logout</button>
    } else {
      return <button type='submit' onClick={this.handleLogin}>Login</button>
    }
  }

  render() {
    return (
      <nav>
        {this.renderButton()}
      </nav>
    )
  }
}

HeaderContainer.peropTypes = propTypes;
export default connect(mapStateToProps, mapDispatchToProps)(HeaderContainer);
