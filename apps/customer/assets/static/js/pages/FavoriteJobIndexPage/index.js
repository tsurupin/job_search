import React, { PropTypes, Component } from 'react';

import {
  HeaderContainer,
  FavoriteJobIndexContainer
} from 'containers';

class FavoriteJobIndexPage extends Component {

  constructor(props) {
    super(props)
  }

  render() {
    return (
      <article>
        <HeaderContainer />
        <FavoriteJobIndexContainer />
      </article>
    )

  }
}

export default FavoriteJobIndexPage