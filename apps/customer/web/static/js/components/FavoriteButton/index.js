import React, { PropTypes } from 'react';

const propTypes = {
  jobId: PropTypes.number.isRequired,
  favorited: PropTypes.bool.isRequired,
  submitting: PropTypes.bool.isRequired,
  index: PropTypes.number.isRequired,
  handleSwitchFavoriteStatus: PropTypes.func.isRequired
};

const FavoriteJobButton = ({jobId, favorited, submitting, index, handleSwitchFavoriteStatus}) => {

    return(
        <button
            className="button"
            type="button"
            onClick={() => handleSwitchFavoriteStatus(index, jobId, !favorited)}
            disabled={submitting}
        >
          {renderText(favorited)}
        </button>
    )
}

function renderText(favorited) {
    if(favorited) { return "UnFavorite"}
    return "Favorite"
}

FavoriteJobButton.propTypes = propTypes;
export default FavoriteJobButton;