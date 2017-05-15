import React, { Component } from 'react';
import PropTypes from 'prop-types';
import {
  FavoriteJobIndexContainer
} from 'containers';

class FavoriteJobIndexPage extends Component {

  constructor(props) {
    super(props)
  }

  render() {
    return (
      <article>
        <FavoriteJobIndexContainer />
      </article>
    )

  }
}

export default FavoriteJobIndexPage